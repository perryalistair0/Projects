import 'package:flutter/material.dart';
import 'package:society_app/pages/authenticate/create_account_page.dart';
import 'package:society_app/pages/authenticate/sign_in_page.dart';

// Authentication switched, sign in or create account
// Author - Mark Gawlyk & Duncan MacLachlan

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

//Sign in page wrapper
class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  //Display SignIn or CreateAccount page
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return CreateAccount(toggleView: toggleView);
    }
  }
}
