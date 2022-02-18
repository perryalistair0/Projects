import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import numpy as np

# Part a) Housing prices
# ======================

fig = plt.figure(figsize=(19.20, 10.80))
plt.subplots_adjust(hspace=0.3)
plt.subplot(2, 2, 1)
# path = "Data/HousingPrices/Average-prices-Property-Type-2021-05_subset.csv"
path = "Data/HousingPrices/Average-prices-Property-Type-2021-05.csv"
df = pd.read_csv(path)
pd.set_option('precision', 0)

london_row = df.iloc[-2]
newcastle_row = df.iloc[-1]

data_arr = []
LondonCityList = ['London', 'Outer London', 'Inner London']
NorthEastCityList = ['Newcastle upon Tyne', 'Middlesbrough', 'Sunderland', 'Gateshead']
HouseList = ['Detached_Average_Price', 'Semi_Detached_Average_Price', 'Terraced_Average_Price', 'Flat_Average_Price']
colours = ['#762a83', '#af8dc3', '#4c0054', '#000840', '#00332f', '#7fbf7b', '#1b7837']

bardwidth = 0.05
r1 = [x for x in range(4)]
CityListList = [LondonCityList, NorthEastCityList]
hatch = "\\\\"
color_index = 0
for CityList in CityListList:
    for city in CityList:
        r1 = [x + bardwidth for x in r1]
        temp_data = []
        query = df.loc[(df['Region_Name'] == city)]
        temp_row = query.iloc[-1]
        temp_data = [temp_row['Detached_Average_Price'], temp_row['Semi_Detached_Average_Price'],
                     temp_row['Terraced_Average_Price'], temp_row['Flat_Average_Price']]
        plt.bar(r1, temp_data, width=bardwidth, label=city, hatch=hatch, color=colours[color_index])
        color_index += 1
    hatch = ""

labels = ['Detached', 'Semi detached', 'Terraced', 'Flat']
plt.xticks([x + 0.2 for x in range(4)], labels)

plt.xlabel("Type of Housing")
plt.ylabel("Housing price (£1,000,000)")
plt.title("Housing price 2021", fontweight="bold")

region1 = mpatches.Patch(facecolor=[168 / 256, 175 / 256, 175 / 256], hatch='\\\\', label='Greater London')
region2 = mpatches.Patch(facecolor=[168 / 256, 175 / 256, 175 / 256], hatch='', label='North East')
legend1 = plt.legend(handles=[region1, region2], title="Regions", loc=9)
plt.gca().add_artist(legend1)
plt.legend(title="Cities")

# Part B) Broadband speed
# =======================
plt.subplot(2, 2, 2)
path1 = "Data/BroadbandSpeed/202006_fixed_laua_performance_wrangled.csv"
df1 = pd.read_csv(path1)

plt.xlabel('Download speed (Mb/s)')
plt.ylabel('Upload speed (Mb/s)')

plt.scatter(df1['averageDown'], df1['averageUpload'], s=5, c=(df1['averageUpload'] + df1['averageDown']), cmap='PRGn')

gradient, intercept = np.polyfit(df1['averageDown'], df1['averageUpload'], 1)
# plt.plot(xVal, gradient*xVal + intercept)
plt.plot(df1['averageDown'], gradient * df1['averageDown'] + intercept, c='r')
rectangle = mpatches.Rectangle((29, 3), 80, 70,
                               fill=False,
                               color="black",
                               linewidth=1)
plt.gca().add_patch(rectangle)

df1['outlier'] = (df1['averageDown'] > 140) | (df1['averageUpload'] > 80)
outlier_points = df1.loc[(df1['outlier'] == True)]
plt.scatter(outlier_points['averageDown'], outlier_points['averageUpload'], s=5, c='r')
for index, rows in outlier_points.iterrows():
    plt.annotate(rows['laua_name'].split(",")[0].capitalize(), (rows['averageDown'], rows['averageUpload']),
                 horizontalalignment='right')

r = df1['averageDown'].corr(df1['averageUpload'])

plt.title("Average upload and download speeds of UK cities r=" + str(round(r, 3)), fontweight="bold")

# Part C) Financial data
# ======================
plt.subplot(2, 2, 3)
path2 = "Data/FTSE/ftse_data_wrangled.csv"
df2 = pd.read_csv(path2)
# all_data['date']= pd.to_datetime(all_data['date'],format="%Y-%m-%d")
df2['date'] = pd.to_datetime(df2['date'], format="%Y-%m-%d")
df2 = df2[df2['date'] > '2019-01-01']
plt.plot(df2['date'], df2['Close'], label='Close price', alpha=0.8, linewidth=1, c='#01665e')

# Highlighting fall
fall_points = df2.loc[(df2['date'] == '2020-02-20') | (df2['date'] == '2020-03-20')]
first_point = fall_points.iloc[0]
second_point = fall_points.iloc[1]
plt.annotate("20th February ", (first_point['date'], first_point['Close']))
plt.annotate("20th March", (second_point['date'], second_point['Close']))
plt.scatter([first_point['date'], second_point['date']], [first_point['Close'], second_point['Close']], c='k')
plt.axvline(x=first_point['date'], c='k', linestyle='--', linewidth=0.6)
plt.axvline(x=second_point['date'], c='k', linestyle='--', linewidth=0.6)

rolling_average = df2['Close'].rolling(7).mean()
# plt.plot(df2['date'], rolling_average, label='Rolling average', c='b')

std = df2['Close'].rolling(7).std()
bollup = rolling_average + std * 2.0
bolldown = rolling_average - std * 2.0
plt.plot(df2['date'], bollup, linestyle='--', c='#b35806', alpha=0.8, linewidth=1, label='Top bollinger band')
plt.plot(df2['date'], bolldown, linestyle='--', c='#542788', alpha=0.8, linewidth=1, label='Bottom bollinger band')

ymean = [df2['Close'].mean()] * len(df2['date'])
plt.plot(df2['date'], ymean, label='Mean', linestyle=':', c='#b2182b')

plt.title("FTSE closing prices (GBP) 2021", fontweight="bold")
plt.xticks(rotation=45)
plt.ylabel("Price (GBP)")
plt.xlabel("Date")
plt.legend()

# Part D) Narrative
# =================
NarrativeText = """
Part a) 
This graph demonstrates a large gap in housing prices between Greater London and the Northeast. As you can see from the bar chart,
the different London areas are more than twice the price of any City in the Northeast. Between the different housing, it seems to 
be that the more compact the housing is, the cheaper it is. With detached taking up the most space, we can see how the impact on 
pricing is extreme with a detached house in central London being the most expensive form of living by a large margin. On the other 
hand, flats take up the least amount of space and so are the cheapest, which can be seen by the fact that a detached house in 
Newcastle costs the same as a flat in outer London despite London pricing being normally double a house in the Northeast.  

Part b)  
Upload and download speed have a weak correlation of 0.34. Looking at the graph, there’s a tight  clustering around the regression 
line at the bottom of the graph with the data that doesn’t cluster having a high spread. In combination with the fact the data follows 
a flat regression line, there seems to be a large group of cities with consistently bad upload speed and varying amount of download speed.  

York’s speeds are the most anomalous, falling extremely far from the regression line. Since it deviates from the data’s pattern so much, 
it’s extremely likely that there was a mistake when taking York’s measurements and can be ignored as a data point. Although Kingston 
upon Hull’s speed is far outside the bulk of data, it still falls upon the regression line it's more likely that; its internet speeds 
are faster  than the rest of the UK.  

Part C)  
Aside from the start of 2020, the FTSE stock price is consistent. Before 2020, the price stays around £7,000 to £7,500 and around the 
start of 2021 the price stays around £6,500 to £7,000. The sharp drop in price occurs from February to March, which coincides with the 
start of the Covid 19 pandemic. Furthermore, the gap between the bollinger lines demonstrate the volatility of this drop. It's shown that, 
the price increased somewhat throughout the lockdowns of 2020 and increases sharply at towards the start of 2021 when the UK started 
its vaccination program. This clearly demonstrates that  covid has had a direct impact on confidence in the market, and the economy.  
"""

plt.subplot(2, 2, 4)

plt.text(0, 0, NarrativeText, fontsize=7, verticalalignment='bottom')
plt.axis('off')
fig.savefig('Image.png', format='png')
plt.show()
