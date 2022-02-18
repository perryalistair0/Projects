import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:society_app/services/auth.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

// Forgotten Password Page, form to input a valid email and send password
// reset email
// Author - Mark Gawlyk

class ForgottenPassword extends StatefulWidget {
  @override
  _ForgottenPasswordState createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> {
  //Get instance of Firebase Auth
  final AuthService _auth = AuthService();

  TextEditingController _controller = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  //Form variables
  String email = "";
  String message = "";
  final _formKey = GlobalKey<FormState>();

  //Form layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgotten Password',
          style: TextStyle(),
        ),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Text(
                "Enter your university email address.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _controller,
                obscureText: false,
                style: style,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Email (@newcastle.ac.uk)",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0))),
                validator: Validators.compose([
                  Validators.required('Enter valid email'),
                  Validators.email('Enter valid email'),
                ]),
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xFF283593),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if (await _auth.resetPassword(email) != false) {
                        setState(() {
                          message = "Password reset has been sent.";
                          _controller.clear();
                        });
                      } else {
                        setState(() {
                          message = "No email found.";
                          _controller.clear();
                        });
                      }
                    } else {
                      setState(() {});
                    }
                  },
                  child: Text(
                    "Reset Password",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
