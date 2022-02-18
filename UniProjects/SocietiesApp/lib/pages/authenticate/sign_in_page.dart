import 'package:flutter/material.dart';
import 'package:society_app/pages/authenticate/forgotten_password.dart';
import 'package:society_app/services/auth.dart';
import 'package:society_app/shared/loading.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

// Sign in page, sign in form and 'create account'/'forgotten password' buttons
// Author - Duncan MacLachlan

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  //Get instance of Firebase Auth
  final AuthService _auth = AuthService();

  bool loading = false;

  //Form variables
  String email = "";
  String password = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //Email field
    final emailField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email (@newcastle.ac.uk)",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: Validators.compose([
        Validators.required('Enter valid email'),
        Validators.email('Enter valid email'),
      ]),
      onChanged: (val) {
        setState(() {
          email = val;
        });
      },
    );

    //Password field
    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: Validators.required('Enter password'),
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
    );

    //Login Button
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF283593),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              loading = true;
            });
            dynamic result = await _auth.signInEmailPassword(email, password);
            if (result == null) {
              setState(() {
                loading = false;
              });
              print("login failed");
            } else {
              print("signed in");
              print(result.uid);
            }
          } else {
            setState(() {});
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    //Navigate to Create Account
    final newUserButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFFD32F2F),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          widget.toggleView();
        },
        child: Text("Create account",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    //Navigate to forgotten password
    final passwordLink = Container(
        child: FlatButton(
      textColor: Colors.indigo,
      child: Text(
        'Forgotten password?',
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgottenPassword()),
        );
      },
    ));

    //Display loading spinner while data loads
    //Display Form when not loading
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'NUSU Societies App',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.blue[900],
              centerTitle: true,
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
                          SizedBox(height: 45.0),
                          emailField,
                          SizedBox(height: 25.0),
                          passwordField,
                          SizedBox(height: 35.0),
                          loginButon,
                          SizedBox(height: 15.0),
                          newUserButton,
                          SizedBox(height: 10.0),
                          passwordLink,
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
