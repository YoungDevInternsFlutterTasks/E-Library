import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Currentuser extends ChangeNotifier {
  late String _uid;
  late String _email;

  String get getUid => _uid;

  String get getEmail => _email;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser(String email, String password) async {
    String retVal = "error";

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      retVal = "success";
    } catch (e) {
      retVal = (e as FirebaseAuthException).message!;
    }
    return retVal;
  }

  Future<String> LoginUserWithEmail(String email, String password) async {
    String retVal = "error";

    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      _uid = _authResult.user!.uid;
      _email = _authResult.user!.email!;
      retVal = "success";
    } catch (e) {
      retVal = (e as FirebaseAuthException).message!;
    }
    return retVal;
  }
}
