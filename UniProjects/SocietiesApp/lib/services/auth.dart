import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:society_app/models/user.dart';
import 'package:society_app/services/database.dart';

class AuthService {
  //Firebase Authentication calls done in this file.
  // Duncan MacLachlan, Mark Gawlyk

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _userFromFirebaseUser(User user) {
    if (user != null) {
      return AppUser(uid: user.uid);
    } else {
      return null;
    }
  }

  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signUpEmailPassword(String email, String password, String firstName,
      String surname, String studentNumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user;

      await DatabaseService(uid: user.uid)
          .updateUserData(firstName, surname, studentNumber);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user;
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (ds.exists) {
        return _userFromFirebaseUser(user);
      } else {
        print("ADMIN ACCOUNT");
        _auth.signOut();
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return false;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
