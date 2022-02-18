import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_app/models/post.dart';
import 'package:society_app/models/reaction.dart';
import 'package:society_app/pages/home/event_post_card.dart';
import 'package:society_app/pages/home/plain_post_card.dart';
import 'package:society_app/services/database.dart';
import 'package:society_app/shared/loading.dart';

//fetches and displays all posts from either a single society, or from all
// societies enrolled by the current user
// Author - Mark Gawlyk
// Modified By - Duncan MacLachlan

class PostList extends StatefulWidget {
  //parameters
  final bool isNewsfeed;
  final String socID;
  PostList({this.isNewsfeed, this.socID});

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  //stateless variables
  String author = "Loading name";
  String socName = "Loading soc";
  List<Post> posts = new List<Post>.empty(growable: true);

  //widget tree (for single society)
  @override
  Widget build(BuildContext context) {
    return !widget.isNewsfeed
        ? StreamBuilder(
            stream: DatabaseService().getSocPosts(widget.socID),
            builder: (context, postsSnapshot) {
              if (postsSnapshot.data != null) {
                return ListView.builder(
                  itemCount: postsSnapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = postsSnapshot.data.documents[index];
                    posts.add(postFromDocSnapshot(ds));
                    return StreamBuilder(
                      stream:
                          DatabaseService().getUserFromUid(posts[index].uid),
                      builder: (context, usersSnapshot) {
                        return StreamBuilder(
                          stream: DatabaseService()
                              .getSocFromSocID(posts[index].socID),
                          builder: (context, socSnapshot) {
                            if (socSnapshot.hasData) {
                              socName = socSnapshot.data["name"];
                            }
                            if (usersSnapshot.data != null) {
                              author = (usersSnapshot.data["firstName"] +
                                  " " +
                                  usersSnapshot.data["surname"]);
                            }
                            if (posts[index].type == "Event") {
                              return EventPostCard(
                                post: posts[index],
                                author: author,
                                socName: socName,
                              );
                            } else {
                              return PlainPostCard(
                                post: posts[index],
                                author: author,
                                socName: socName,
                              );
                            }
                          }, //PostCard(post: posts[index])
                        );
                      }, //PostCard(post: posts[index])
                    );
                  },
                );
              } else {
                return Loading();
              }
            })
        //widget tree (for newsfeed)
        : StreamBuilder(
            stream: DatabaseService().getUsersSocs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> socIDs = List<String>.empty(growable: true);
                for (int i = 0; i < snapshot.data.documents.length; i++) {
                  socIDs.add(snapshot.data.documents[i].data()["societyID"]);
                }
                return !(socIDs.length > 0)
                    ? (Center(
                        child: Text("Join some societies!"),
                      ))
                    : StreamBuilder(
                        stream: DatabaseService().getSocsPosts(socIDs),
                        builder: (context, postsSnapshot) {
                          if (postsSnapshot.data != null) {
                            return ListView.builder(
                              itemCount: postsSnapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                    postsSnapshot.data.documents[index];
                                posts.add(postFromDocSnapshot(ds));
                                return StreamBuilder(
                                  stream: DatabaseService()
                                      .getUserFromUid(posts[index].uid),
                                  builder: (context, usersSnapshot) {
                                    return StreamBuilder(
                                      stream: DatabaseService()
                                          .getSocFromSocID(posts[index].socID),
                                      builder: (context, socSnapshot) {
                                        if (socSnapshot.hasData) {
                                          socName = socSnapshot.data["name"];
                                        }
                                        if (usersSnapshot.data != null) {
                                          author = (usersSnapshot
                                                  .data["firstName"] +
                                              " " +
                                              usersSnapshot.data["surname"]);
                                        }
                                        //return EventPostCard or PlainPostCard depending on post type
                                        if (posts[index].type == "Event") {
                                          return EventPostCard(
                                            post: posts[index],
                                            author: author,
                                            socName: socName,
                                          );
                                        } else {
                                          return PlainPostCard(
                                            post: posts[index],
                                            author: author,
                                            socName: socName,
                                          );
                                        }
                                      }, //PostCard(post: posts[index])
                                    );
                                  }, //PostCard(post: posts[index])
                                );
                              },
                            );
                          } else {
                            return Loading();
                          }
                        });
              } else {
                return Loading();
              }
            });
  }

  //post object from a document snapshot
  Post postFromDocSnapshot(DocumentSnapshot ds) {
    return new Post(
      postID: ds.id,
      uid: ds.data()["uid"] ?? null,
      dateTime: ds.data()["dateTime"] ?? null,
      socID: ds.data()["societyID"] ?? null,
      type: ds.data()["type"] ?? "Text",
      isAdmin: ds.data()["isAdmin"] ?? false,
      body: ds.data()['body'] ?? "BodyNotFound",
      reactions: new List<Reaction>.empty(growable: true),
    );
  }
}
