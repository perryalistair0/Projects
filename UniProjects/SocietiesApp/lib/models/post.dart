import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:society_app/models/reaction.dart';

// Post class, used when retrieving posts from the database
// Author - Mark Gawlyk

class Post {
  String postID;
  String uid;
  String author;
  Timestamp dateTime;
  String body;
  String socID;
  String type;
  bool isAdmin;
  List<Reaction> reactions;
  DateTime timeStamp;

  Post(
      {this.postID,
      this.socID,
      this.isAdmin,
      this.type,
      this.uid,
      this.author,
      this.dateTime,
      this.body,
      this.reactions,
      this.timeStamp});
}
