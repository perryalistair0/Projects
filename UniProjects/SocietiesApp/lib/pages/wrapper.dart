import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_app/models/user.dart';
import 'package:society_app/pages/authenticate/authenticate.dart';
import 'package:society_app/pages/home/navigation_bar.dart';

// App authentication wrapper - Mark Gawlyk

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    //Prevent access to app by unauthorised users
    if (user == null) {
      return Authenticate();
    } else {
      return Navigation();
    }
  }
}
