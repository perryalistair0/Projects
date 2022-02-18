import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:society_app/models/user.dart';
import 'package:society_app/services/database.dart';

//Display events post information in simple layout, for calendar page
// Author - Mark Gawlyk

class EventView extends StatefulWidget {
  final String postID;
  EventView({this.postID});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  //variables
  bool liked = false;
  int numberOfLikes = 0;

  //check if current user has liked post
  checkIfLikedOrNot() async {
    DocumentSnapshot ds = await DatabaseService().getUserLike(widget.postID);
    this.setState(() {
      liked = ds.exists;
    });
  }

  void initState() {
    super.initState();
    checkIfLikedOrNot();
  }

  //build Event Card for calendar page
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().getPostFromID(widget.postID),
      builder: (context, postSnapshot) {
        if (!postSnapshot.hasData) {
          return SizedBox(height: 0);
        } else if (DateTime.now()
            .isBefore(postSnapshot.data["dateTime"].toDate())) {
          return StreamBuilder(
            stream: DatabaseService().getUserLikeStream(widget.postID),
            builder: (context, likesSnapshot) {
              if (!likesSnapshot.hasData) {
                return Card(
                    child: SizedBox(
                  height: 0,
                ));
              } else {
                if (likesSnapshot.data.documents.length > 0) {
                  return Card(
                    margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            postSnapshot.data["body"],
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd – kk:mm')
                                .format(postSnapshot.data["dateTime"].toDate()),
                          ),
                          OutlineButton(
                            child: Text(
                              "Going",
                              style: TextStyle(
                                color:
                                    liked ? Colors.blue[900] : Colors.grey[500],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            borderSide: BorderSide(
                                color:
                                    liked ? Colors.blue[900] : Colors.grey[500],
                                width: 2),
                            onPressed: () async {
                              final user =
                                  Provider.of<AppUser>(context, listen: false);
                              final String userDisplayName =
                                  await DatabaseService().getName(user.uid);
                              await DatabaseService().toggleLikePost(user.uid,
                                  userDisplayName, widget.postID, "going");

                              setState(() {
                                checkIfLikedOrNot();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox(height: 0);
                }
              }
            },
          );
        } else {
          return SizedBox(height: 0);
        }
      },
    );
  }
}
