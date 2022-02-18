import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_app/models/user.dart';
import 'package:society_app/services/database.dart';

//Event Post creator, form to input body, and pop ups to select date and time
// Author - Mark Gawlyk
// Modified By - Duncan MacLachlan

class CreateDatedPost extends StatefulWidget {
  final socID;
  CreateDatedPost({this.socID});

  @override
  _CreateDatedPostState createState() => _CreateDatedPostState();
}

class _CreateDatedPostState extends State<CreateDatedPost> {
  String body = "";

  DateTime chosenDate;
  TimeOfDay chosenTime;

  //returns current time
  String _getCurrentTime() {
    if (chosenDate.minute < 10) {
      return ("${chosenDate.hour}:0${chosenDate.minute}");
    } else {
      return ("${chosenDate.hour}:${chosenDate.minute}");
    }
  }

  //returns current date
  String _getCurrentDate() {
    String month, day;
    if (chosenDate.day < 10) {
      day = "0${chosenDate.day}";
    } else {
      day = "${chosenDate.day}";
    }

    if (chosenDate.month < 10) {
      month = "0${chosenDate.month}";
    } else {
      month = "${chosenDate.month}";
    }

    return ("$day/$month/${chosenDate.year}");
  }

  @override
  void initState() {
    super.initState();
    chosenDate = DateTime.now();
    chosenTime = TimeOfDay.now();
  }

  @override
  //Displays form to create an Event Post
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
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        _pickDate();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Date: ${_getCurrentDate()}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        _pickTime();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Time: ${_getCurrentTime()}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
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
                      final user = Provider.of<AppUser>(context, listen: false);
                      final DateTime timeStamp = DateTime.now();
                      await DatabaseService().createEventPost(
                          body, chosenDate, user.uid, timeStamp, widget.socID);
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

  //Pop up to select a time
  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: chosenTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[900],
            ),
            primaryColor: Colors.blue[900],
          ),
          child: child,
        );
      },
    );
    if (t != null)
      setState(() {
        chosenTime = t;
        chosenDate = new DateTime(chosenDate.year, chosenDate.month,
            chosenDate.day, chosenTime.hour, chosenTime.minute);
      });
  }

  //Pop up to select a date
  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: chosenDate,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[900],
            ),
            primaryColor: Colors.blue[900],
          ),
          child: child,
        );
      },
    );
    if (date != null)
      setState(() {
        chosenDate = DateTime(date.year, date.month, date.day, chosenTime.hour,
            chosenTime.minute);
      });
  }
}
