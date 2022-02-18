import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:society_app/models/post.dart';
import 'package:society_app/models/user.dart';
import 'package:society_app/services/database.dart';
import 'package:intl/intl.dart';

//Display event post provided, submit 'going', view users 'going'
// Author - Mark Gawlyk
// Comments area below post - Duncan MacLachlan

class EventPostCard extends StatefulWidget {
  final Post post;
  final String author;
  final String socName;
  EventPostCard({
    this.post,
    this.author,
    this.socName,
  });

  @override
  _EventPostCardState createState() => _EventPostCardState();
}

class _EventPostCardState extends State<EventPostCard> {
  TextEditingController commentController = TextEditingController();

  //variables
  String commentBody = "";
  bool liked = false;
  int numberOfLikes = 0;
  bool admin = false;

  // get worded number of responses
  String _getWordedLikeCount() {
    if (numberOfLikes == 0) {
      return "No One Going";
    } else {
      return "$numberOfLikes Going";
    }
  }

  //Check is current user has responded to the post
  checkIfLikedOrNot() async {
    DocumentSnapshot ds =
        await DatabaseService().getUserLike(widget.post.postID);
    this.setState(() {
      liked = ds.exists;
    });
  }

  //Get the number of responses
  checkNumberOfLikes() async {
    QuerySnapshot qs = await DatabaseService().getLikes(widget.post.postID);
    this.setState(() {
      if (qs == null) {
        numberOfLikes = -1;
      } else {
        numberOfLikes = qs.docs.length;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkIfLikedOrNot();
    checkNumberOfLikes();
    if (widget.post.isAdmin) {
      admin = true;
    }
  }

  //Display Event Post Card
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              //widget.post.dateTime.toDate().toString(),
              "Upcoming Event: " +
                  DateFormat('yyyy-MM-dd – kk:mm')
                      .format(widget.post.dateTime.toDate()),
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              widget.post.body,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[900],
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              (widget.author + " - " + widget.socName),
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 6.0),
            Row(
              children: <Widget>[
                OutlineButton(
                  child: Text(
                    "Going",
                    style: TextStyle(
                      color: liked ? Colors.blue[900] : Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  borderSide: BorderSide(
                      color: liked ? Colors.blue[900] : Colors.grey[500],
                      width: 2),
                  onPressed: () async {
                    final user = Provider.of<AppUser>(context, listen: false);
                    final String userDisplayName =
                        await DatabaseService().getName(user.uid);
                    await DatabaseService().toggleLikePost(
                        user.uid, userDisplayName, widget.post.postID, "going");
                    setState(() {
                      checkIfLikedOrNot();
                      checkNumberOfLikes();
                    });
                  },
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _viewReactions(context, widget.post);
                    });
                  },
                  child: Text(
                    _getWordedLikeCount(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
                stream: DatabaseService().getComments(widget.post.postID),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return new Text("Loading...");
                  return new ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data.documents.length == 0) {
                          return Text("");
                        }
                        DocumentSnapshot ds = snapshot.data.documents[index];
                        return new Text(
                            ds["author"] + ": " + ds["commentBody"]);
                        //return Text("Has Data");
                      });
                }),
            ListTile(
                title: TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(labelText: "Write a comment:"),
                  onChanged: (val) {
                    setState(() {
                      commentBody = val;
                    });
                  },
                ),
                trailing: OutlineButton(
                  onPressed: () async {
                    final user = Provider.of<AppUser>(context, listen: false);
                    await DatabaseService().createComment(
                        widget.post.postID, user.uid, commentBody);
                    commentController.clear();
                  },
                  child: Text("Post"),
                  borderSide: BorderSide.none,
                )),
          ],
        ),
      ),
    );
  }
}

//Show bottom modal sheet, display list of users who are 'going' to an event
void _viewReactions(context, Post post) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Going:",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                      stream: DatabaseService().getLikesStream(post.postID),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("Loading...");
                        } else {
                          return new ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data.documents.length == 0) {
                                  return Text("");
                                }
                                DocumentSnapshot ds =
                                    snapshot.data.documents[index];
                                return new Text(
                                    ds["author"] + ": " + ds["data"]);
                                //return Text("Has Data");
                              });
                        }
                      }),
                ),
              ],
            ),
          ),
        );
      });
}
