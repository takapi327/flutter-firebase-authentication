import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthStore extends ChangeNotifier {
  String userEmail    = "";
  String userPassword = "";
  String infoText     = "";
  bool   isLoading    = false;

  late User user;

  void changeLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void changeEmail(String email) {
    userEmail = email;
    notifyListeners();
  }

  void changePassword(String pass) {
    userPassword = pass;
    notifyListeners();
  }

  void changeInfoText(String text) {
    infoText = text;
    notifyListeners();
  }

  void authentication(User user) {
    user = user;
    notifyListeners();
  }

  Future<UserCredential> signUp() {
    final  FirebaseAuth auth = FirebaseAuth.instance;
    return auth.createUserWithEmailAndPassword(
        email:    userEmail,
        password: userPassword
    );
  }

  Future<UserCredential> login() {
    final  FirebaseAuth auth = FirebaseAuth.instance;
    return auth.signInWithEmailAndPassword(
        email:    userEmail,
        password: userPassword
    );
  }
}
