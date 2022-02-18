import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:society_app/models/post.dart';
import 'package:society_app/models/user.dart';
import 'package:society_app/services/database.dart';

// Display admin post given, like and unlike, view likes
// Author - Mark Gawlyk
// Comments Section below post
// Author - Duncan MacLachlan

class AdminPostCard extends StatefulWidget {
  final Post post;
  final String author;
  final String socName;
  AdminPostCard({
    this.post,
    this.author,
    this.socName,
  });

  @override
  _AdminPostCardState createState() => _AdminPostCardState();
}

class _AdminPostCardState extends State<AdminPostCard> {
  TextEditingController commentController = TextEditingController();

  //Variables
  String commentBody = "";
  bool liked = false;
  int numberOfLikes = 0;

  //generates a worded like count
  String _getWordedLikeCount() {
    if (numberOfLikes == 0) {
      return "No Likes";
    } else if (numberOfLikes == 1) {
      return "1 Like";
    } else {
      return "$numberOfLikes Likes";
    }
  }

  //checks if current user has liked a post
  checkIfLikedOrNot() async {
    DocumentSnapshot ds =
        await DatabaseService().getUserLike(widget.post.postID);
    this.setState(() {
      liked = ds.exists;
    });
  }

  //checks the number of likes a post has
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
  }

  @override
  Widget build(BuildContext context) {
    //Displays a 'post' card, showing data from an admin post
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.post.body,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[900],
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              ("ADMIN" + " - " + widget.socName),
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 6.0),
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    final user = Provider.of<AppUser>(context, listen: false);
                    final String userDisplayName =
                        await DatabaseService().getName(user.uid);

                    await DatabaseService().toggleLikePost(
                        user.uid, userDisplayName, widget.post.postID, "like");
                    setState(() {
                      checkIfLikedOrNot();
                      checkNumberOfLikes();
                    });
                  },
                  icon: Icon(
                    Icons.thumb_up,
                    color: liked ? Colors.blue[900] : Colors.grey[500],
                  ),
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

void _viewReactions(context, Post post) {
//Displays the names of users who have liked the post
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
                  "Likes:",
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
