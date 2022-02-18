import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_app/pages/home/event_view.dart';
import 'package:society_app/services/database.dart';
import 'package:society_app/shared/loading.dart';

// Calendar Page, display all posts a user is 'going' to in date order
// Author - Mark Gawlyk

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    //displays all events that a user has responded 'going' to
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Calendar Page"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: StreamBuilder(
          stream: DatabaseService().getEventPosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else if (snapshot.data.documents.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  return EventView(postID: ds.id);
                },
              );
            } else {
              return Text("");
            }
          }),
    );
  }
}
