import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_app/models/user.dart';
import 'package:society_app/services/database.dart';

//Create Text Post Page, form to input a body of text and publish post
// Author - Mark Gawlyk
// Modified By - Duncan MacLachlan

class CreateTextsPost extends StatefulWidget {
  final socID;
  CreateTextsPost({this.socID});
  @override
  _CreateTextsPostState createState() => _CreateTextsPostState();
}

class _CreateTextsPostState extends State<CreateTextsPost> {
  String body = "";

  //Form to create a text post
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(new Radius.circular(10.0)),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Post text...',
                  focusColor: Colors.white,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    body = val;
                  });
                },
                keyboardType: TextInputType.multiline,
                maxLines: 8,
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                  child: FlatButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.blue[900],
                    padding: EdgeInsets.all(10),
                    onPressed: () async {
                      // Navigator.pushNamed(context, '/feed');
                      final DateTime timeStamp = DateTime.now();
                      final user = Provider.of<AppUser>(context, listen: false);
                      await DatabaseService().createTextPost(
                          body, user.uid, timeStamp, widget.socID);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Publish",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
