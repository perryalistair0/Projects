import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // All calls and queries to the database performed through this file.
  // All team members contributed.

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection("posts");

  final CollectionReference membershipCollection =
      FirebaseFirestore.instance.collection("memberships");

  final CollectionReference socCollection =
      FirebaseFirestore.instance.collection("societies");

  final CollectionReference goingCollection =
      FirebaseFirestore.instance.collection("going");

  Future updateUserData(
      String firstName, String surname, String studentNumber) async {
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'surname': surname,
      'studentNumber': studentNumber,
    });
  }

  Future<QuerySnapshot> getLikes(String postID) {
    return postCollection.doc(postID).collection("likes").get();
  }

  Stream<QuerySnapshot> getLikesStream(String postID) {
    return postCollection.doc(postID).collection("likes").snapshots();
  }

  Stream<QuerySnapshot> getComments(String postID) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postID)
        .collection("comments")
        .snapshots();
  }

  Stream<DocumentSnapshot> getPostFromID(String postID) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postID)
        .snapshots();
  }

  Stream<QuerySnapshot> getSocPosts(String socID) {
    return postCollection
        .orderBy("timeStamp", descending: true)
        .where("societyID", isEqualTo: socID)
        .snapshots();
  }

  Stream<QuerySnapshot> getSocsPosts(List<String> socIDs) {
    return postCollection
        .orderBy("timeStamp", descending: true)
        .where("societyID", whereIn: socIDs)
        .snapshots();
  }

  Stream<QuerySnapshot> getEventPosts() {
    return postCollection
        .where("type", isEqualTo: "Event")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUsersSocs() {
    return membershipCollection
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getSocietyInfo(String socID) {
    return socCollection.doc(socID).collection('society info').snapshots();
  }

  Stream<QuerySnapshot> getSocialInfo(String socID) {
    return socCollection.doc(socID).collection('social info').snapshots();
  }

  Stream<DocumentSnapshot> getUserFromUid(String uid) {
    return userCollection.doc(uid).snapshots();
  }

  Stream<DocumentSnapshot> getSocFromSocID(String socID) {
    return socCollection.doc(socID).snapshots();
  }

  Stream<QuerySnapshot> getSocieties() {
    return socCollection.snapshots();
  }

  Stream<QuerySnapshot> getUserLikeStream(String postID) {
    return postCollection
        .doc(postID)
        .collection("likes")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserLike(String postID) {
    return postCollection
        .doc(postID)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
  }

  Stream<DocumentSnapshot> getSocMembership(socID) {
    return membershipCollection
        .doc(FirebaseAuth.instance.currentUser.uid + "_" + socID)
        .snapshots();
  }

  Future createMembership(socID) {
    return membershipCollection
        .doc(FirebaseAuth.instance.currentUser.uid + "_" + socID)
        .set({
      "societyID": socID,
      "userID": FirebaseAuth.instance.currentUser.uid,
    });
  }

  Future deleteMembership(socID) {
    return membershipCollection
        .doc(FirebaseAuth.instance.currentUser.uid + "_" + socID)
        .delete();
  }

  //create post
  Future createTextPost(
      String body, String uid, DateTime timeStamp, String socID) async {
    return await postCollection.doc().set({
      'type': "Text",
      'body': body,
      'uid': uid,
      'societyID': socID,
      'timeStamp': timeStamp,
    });
  }

  Future createEventPost(String body, DateTime dateTime, String uid,
      DateTime timeStamp, String socID) async {
    return await postCollection.doc().set({
      'type': "Event",
      'dateTime': dateTime,
      'body': body,
      'uid': uid,
      'societyID': socID,
      'timeStamp': timeStamp,
    });
  }

  //comment
  Future createComment(String postID, String uid, String commentBody) async {
    if (commentBody.length > 3) {
      return await postCollection.doc(postID).collection("comments").doc().set({
        'author': await userCollection.doc(uid).get().then((value) =>
            value.data()["firstName"] + " " + value.data()["surname"]),
        'commentBody': commentBody,
      });
    }
    return null;
  }

  //react
  Future toggleLikePost(
      String uid, String author, String postID, String reaction) async {
    DocumentSnapshot ds =
        await postCollection.doc(postID).collection("likes").doc(uid).get();
    if (ds.exists) {
      postCollection.doc(postID).get();
      return await postCollection
          .doc(postID)
          .collection("likes")
          .doc(uid)
          .delete();
    } else {
      return await postCollection.doc(postID).collection("likes").doc(uid).set({
        "uid": uid,
        "author": author,
        "data": reaction,
      });
    }
  }

  Future<String> getName(String uid) {
    return userCollection.doc(uid).get().then(
        (value) => value.data()['firstName'] + " " + value.data()['surname']);
  }
}
