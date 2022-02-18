import 'package:flutter/material.dart';
import 'create_event_post.dart';
import 'create_text_post.dart';

// Create Post Selector, switch between create text post or create event post
// Author - Mark Gawlyk

class CreatePostSelector extends StatefulWidget {
  final socID;
  CreatePostSelector({this.socID});
  @override
  _CreatePostSelectorState createState() => _CreatePostSelectorState();
}

class _CreatePostSelectorState extends State<CreatePostSelector> {
  Widget build(BuildContext context) {
    //Displays a page allowing users to create different posts
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[900],
            centerTitle: true,
            title: Text("Create Post"),
            bottom: TabBar(tabs: <Widget>[
              new Tab(
                child: Column(
                  children: [
                    new Icon(Icons.text_snippet_outlined),
                    new Text('Text')
                  ],
                ),
              ),
              new Tab(
                child: Column(
                  children: [
                    new Icon(Icons.date_range_sharp),
                    new Text('Event')
                  ],
                ),
              ),
            ]),
          ),
          body: new TabBarView(children: <Widget>[
            new CreateTextsPost(socID: widget.socID),
            new CreateDatedPost(socID: widget.socID),
            //new CreatePollPost(),
          ]),
        ));
  }
}
