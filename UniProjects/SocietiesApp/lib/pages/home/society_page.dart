import 'package:flutter/material.dart';
import 'package:society_app/pages/home/post_list.dart';
import 'package:society_app/services/database.dart';
import 'create_post_page.dart';

//Society Page, view society posts and view society details
// Author Takeshi Mark

class SocietyPage extends StatefulWidget {
  final String societyID;
  final String societyName;
  const SocietyPage(this.societyID, this.societyName);
  @override
  _SocietyPageState createState() => _SocietyPageState();
}

//Build society page
class _SocietyPageState extends State<SocietyPage> {
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
                  children: [new Icon(Icons.dynamic_feed), new Text('Posts')],
                ),
              ),
              new Tab(
                child: Column(
                  children: [
                    new Icon(Icons.emoji_objects_sharp),
                    new Text('About')
                  ],
                ),
              )
            ]),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: IconButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreatePostSelector(socID: widget.societyID)));
                  },
                  icon: Icon(Icons.add),
                  color: Colors.white,
                  iconSize: 30.0,
                ),
              ),
            ],
          ),
          body: new TabBarView(children: <Widget>[
            new NewsTab(widget.societyID),
            new InfoTab(widget.societyID),
          ]),
        ));
  }
}

// Info tab to display society details
class InfoTab extends StatefulWidget {
  final String societyID;
  const InfoTab(this.societyID);
  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
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

// Tab to display posts from the current society
class NewsTab extends StatefulWidget {
  final String societyID;
  const NewsTab(this.societyID);
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: PostList(isNewsfeed: false, socID: widget.societyID),
    );
  }
}
