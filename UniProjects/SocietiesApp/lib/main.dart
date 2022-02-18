import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:society_app/models/user.dart';
import 'package:society_app/pages/wrapper.dart';
import 'package:society_app/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(StreamProvider<AppUser>.value(
    value: AuthService().user,
    child: MaterialApp(
      home: Wrapper(),
    ),
  ));
}
