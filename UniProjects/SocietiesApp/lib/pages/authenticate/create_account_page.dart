import 'package:flutter/material.dart';
import 'package:society_app/services/auth.dart';
import 'package:society_app/shared/loading.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

// Create account page, create account form and button to add new user to
// database, button to naviagate to home page
// Author - Duncan MacLachlan



class CreateAccount extends StatefulWidget {
  final Function toggleView;
  CreateAccount({this.toggleView});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

//Create account page
class _CreateAccountState extends State<CreateAccount> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  //get instance of Firebase Auth
  final AuthService _auth = AuthService();

  bool loading = false;

  //Form variables
  String firstName = "";
  String surname = "";
  String studentNumber = "";
  String email = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //First Name input area
    final firstnameField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: Validators.required('Please enter a firstname'),
      onChanged: (val) {
        setState(() {
          firstName = val;
        });
      },
    );

    //Surname input area
    final surnameField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Surname",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: Validators.required('Please enter a surname'),
      onChanged: (val) {
        setState(() {
          surname = val;
        });
      },
    );

    //Student Number input area
    final studentNumberField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Student Number (BXXXXXXX)",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: Validators.compose([
        Validators.required('Student number must be 8 characters long'),
        Validators.minLength(8, 'Student number must be 8 characters long'),
        Validators.maxLength(8, 'Student number must be 8 characters long'),
      ]),
      onChanged: (val) {
        setState(() {
          studentNumber = val;
        });
      },
    );

    //Email input area
    final emailField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email (@newcastle.ac.uk)",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: Validators.compose([
        Validators.required('Email is required'),
        Validators.email('Enter a valid email'),
      ]),
      onChanged: (val) {
        setState(() {
          email = val;
        });
      },
    );

    //Password input area
    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: Validators.compose([
        Validators.patternRegExp(
            RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'),
            'Invalid Password'),
        Validators.required('Invalid password'),
      ]),
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
    );

    //Create Account button to add new account and sign in
    final createAccountButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFFD32F2F),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              loading = true;
            });
            dynamic result = await _auth.signUpEmailPassword(
                email, password, firstName, surname, studentNumber);
            if (result == null) {
              print("signup failed");
              setState(() {
                loading = false;
              });
            } else {
              print("signed up");
              print(result.uid);
            }
          } else {
            setState(() {});
          }
        },
        child: Text("Create account",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    //Display Loading spinner as data is submitted
    //Display Form as when not loading
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'NUSU Societies App',
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              backgroundColor: Colors.blue[900],
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  widget.toggleView();
                },
              ),
            ),
            body: Center(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 150.0,
                            child: Image(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/NCL.png'),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          firstnameField,
                          SizedBox(height: 15.0),
                          surnameField,
                          SizedBox(height: 15.0),
                          studentNumberField,
                          SizedBox(height: 15.0),
                          emailField,
                          SizedBox(height: 15.0),
                          passwordField,
                          SizedBox(height: 15.0),
                          createAccountButton,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
