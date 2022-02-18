import 'package:flutter/material.dart';
import 'package:society_app/pages/home/post_list.dart';
import 'package:society_app/services/auth.dart';

//News feed page to display posts from societies 'current user' is enrolled in
// Author - Mark Gawlyk

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

//Logout button and posts from enrolled societies shown here
class _NewsFeedState extends State<NewsFeed> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Feed',
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            await _auth.signOut();
          },
          icon: Icon(Icons.logout),
          color: Colors.white,
          iconSize: 30.0,
        ),
      ),
      backgroundColor: Colors.grey[300],
      //post list displays posts from all of current users societies
      body: PostList(isNewsfeed: true),
    );
  }
}
