import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_app/models/user.dart';
import 'package:society_app/services/database.dart';

// Search page, retrieves and lists all societies. View society information
// when user navigates to a society. Enroll user when 'join' button is pressed.
// Filter societies with search icon in top corner.
// Author Alistair Perry

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
  //initialise search bar
  SearchBar search = SearchBar();
  //build Browse Societies Page
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Browse Societies'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: search);
            },
          )
        ],
      ),
      body: Center(
        child: new StreamBuilder(
            stream: DatabaseService().getSocieties(),
            builder: (context, snapshot) {
              search.clearSocieties();
              if (!snapshot.hasData) {
                return Text("loading");
              }
              return new ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    search.addSocieties(ds['name'], ds.id, ds['icon']);
                    return new BrowseCard(ds['name'], ds.id, ds['icon']);
                  });
            }),
      ),
    );
  }
}

//Society info 'Page'
class SocietyInfo extends StatefulWidget {
  final String societyID;
  final String societyName;
  const SocietyInfo(this.societyID, this.societyName);
  @override
  _SocietyInfoState createState() => _SocietyInfoState();
}

class _SocietyInfoState extends State<SocietyInfo> {
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
              title: Text(widget.societyName),
              bottom: TabBar(tabs: <Widget>[
                new Tab(
                  child: Column(
                    children: [
                      new Icon(Icons.emoji_objects_sharp),
                      new Text('About')
                    ],
                  ),
                ),
                new Tab(
                  child: Column(
                    children: [new Icon(Icons.share), new Text('Social media')],
                  ),
                )
              ]),
            ),
            body: new TabBarView(children: <Widget>[
              new AboutTab(widget.societyID),
              new SocialTab(widget.societyID),
            ]),
            floatingActionButton: StreamBuilder(
              stream: DatabaseService().getSocMembership(widget.societyID),
              builder: (context, snapshot) {
                var membershipExists = false;
                if (snapshot.data != null) {
                  membershipExists = snapshot.data.exists;
                }
                return FloatingActionButton.extended(
                  onPressed: () {
                    if (!membershipExists) {
                      DatabaseService().createMembership(widget.societyID);
                    } else {
                      DatabaseService().deleteMembership(widget.societyID);
                    }
                  },
                  label: Text('Join'),
                  icon: membershipExists ? Icon(Icons.check) : Icon(Icons.add),
                );
              },
            )));
  }

  //get current user UID
  String getUserID() {
    var user = Provider.of<AppUser>(context, listen: false);
    return user.uid;
  }
}

//search bar class
class SearchBar extends SearchDelegate {
  String result;
  var societies = [];
  var sIDs = [];
  var sIcons = [];
  void addSocieties(String society, String sID, String icon) {
    if (!societies.contains(society)) {
      societies.add(society);
      sIDs.add(sID);
      sIcons.add(icon);
    }
  }

  void clearSocieties() {
    societies.clear();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  // ignore: missing_return
  Widget buildResults(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SocietyInfo(sIDs[societies.indexOf(result)], result)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestionList = [];
    if (query.isEmpty) {
      suggestionList.addAll(societies);
    } else {
      for (var value in societies) {
        if (value.toString().toLowerCase().startsWith(query)) {
          suggestionList.add(value);
        }
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          result = suggestionList[index];
          buildResults(context);
        },
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }
}

//map of icons and names
Map<String, IconData> iconMap = {
  "medical_services": Icons.medical_services,
  "sports_hockey": Icons.sports_hockey,
  "school": Icons.school,
  "person": Icons.person,
  "music_note": Icons.music_note,
  "devices": Icons.devices,
  "science": Icons.science,
  "sports_football": Icons.sports_football,
  "restaurant": Icons.restaurant,
  "face": Icons.face
};

//Browse card to show society names and icons
class BrowseCard extends StatelessWidget {
  final String societyName;
  final String societyID;
  final String icon;
  const BrowseCard(this.societyName, this.societyID, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
        height: 50.0,
        color: Colors.white,
        child: RaisedButton(
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SocietyInfo(societyID, societyName)),
              );
            },
            child: new Row(
              children: [
                Icon(
                  iconMap[icon],
                  size: 32,
                ),
                SizedBox(width: 10),
                Text(
                  societyName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )));
  }
}

//About society 'page'
class AboutTab extends StatefulWidget {
  final String societyID;
  const AboutTab(this.societyID);
  @override
  _AboutTabState createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
            elevation: 30,
            shadowColor: Colors.black,
            child: Padding(
                padding: EdgeInsets.only(left: 35.0, right: 35.0, top: 30.0),
                child: StreamBuilder(
                    stream: DatabaseService().getSocietyInfo(widget.societyID),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var doc = snapshot.data.documents;
                        return ListView.builder(
                          itemCount: doc.length,
                          itemBuilder: (context, index) {
                            return new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Text(
                                  doc[index]['name'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                new Text(
                                  "\n" + doc[index]['info'] + "\n\n",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        return Text('no data :(');
                      }
                    }))));
  }
}

// Society Socials Info 'page'
class SocialTab extends StatelessWidget {
  final societyID;

  SocialTab(this.societyID);
  final Map<String, String> imageMap = {
    "facebook": 'assets/3099aff4115ee20f43e3cdad04f59c48.png',
    "instagram": 'assets/1200px-Instagram_logo_2016.svg.webp',
    "twitter": 'assets/Twitter-Logo.png',
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Card(
            elevation: 30,
            shadowColor: Colors.black,
            child: Padding(
                padding: EdgeInsets.only(left: 35.0, right: 35.0, top: 35.0),
                child: StreamBuilder(
                    stream: DatabaseService().getSocialInfo(societyID),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var doc = snapshot.data.documents;
                        return ListView.builder(
                          itemCount: doc.length,
                          itemBuilder: (context, index) {
                            return new Row(
                              children: [
                                new Image.asset(
                                  getImageLink(doc[index]['name']),
                                  width: 50,
                                  height: 50,
                                ),
                                new Text("   "),
                                new Flexible(
                                  fit: FlexFit.loose,
                                  child: new Text(doc[index]['info']),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        return Text('no data :(');
                      }
                    }))));
  }

  String getImageLink(String name) {
    switch (name) {
      case 'facebook':
        {
          return 'assets/3099aff4115ee20f43e3cdad04f59c48.png';
        }
      case 'instagram':
        {
          return 'assets/1200px-Instagram_logo_2016.svg.webp';
        }
      case 'twitter':
        {
          return 'assets/Twitter-Logo.png';
        }
      default:
        {
          return 'assets/share-01-01-512.webp';
        }
    }
  }
}
