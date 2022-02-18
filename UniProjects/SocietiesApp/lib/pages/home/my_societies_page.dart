import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_app/pages/home/society_page.dart';
import 'package:society_app/services/database.dart';

// Displays list of societies current user is enrolled in, lead to society pages
// when pressed, search functionality
// Author Takeshi Mark

// ignore: must_be_immutable
class MySocieties extends StatelessWidget {
  //initialise search bar
  SearchBar search = SearchBar();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('My Societies'),
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
            stream: DatabaseService().getUsersSocs(),
            builder: (context, snapshot) {
              search.clearSocieties();
              if (!snapshot.hasData) return new Text('loading...');
              return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return new BrowseCard(ds['societyID'], search);
                  });
            }),
      ),
    );
  }
}

// Author Alistair Perry
//Creating Search bar
class SearchBar extends SearchDelegate {
  String result;
  var societies = [];
  var sIDs = [];
  void addSocieties(String society, String sID) {
    if (!(societies.contains(society)) & !(sIDs.contains(sID))) {
      societies.add(society);
      sIDs.add(sID);
    }
  }

  void clearSocieties() {
    societies.clear();
    sIDs.clear();
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
              SocietyPage(sIDs[societies.indexOf(result)], result)),
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

//Map of icons and names
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

// Author Alistair Perry
// Author Takeshi Mark
//Creates a browse card to display society name and icon
class BrowseCard extends StatelessWidget {
  final String societyID;
  final SearchBar search;
  const BrowseCard(this.societyID, this.search);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService().getSocFromSocID(societyID),
        builder: (context, snapshot) {
          var societyName;
          if (!snapshot.hasData) return new Text('loading...');
          DocumentSnapshot ds = snapshot.data;
          societyName = ds['name'];
          search.addSocieties(societyName, ds.id);
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
                          builder: (context) =>
                              SocietyPage(societyID, societyName)),
                    );
                  },
                  child: new Row(
                    children: [
                      new Icon(
                        iconMap[ds['icon']],
                        size: 32,
                      ),
                      new Text(
                        societyName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  )));
        });
  }
}
