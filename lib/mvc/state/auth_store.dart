import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthStore extends ChangeNotifier {
  String userEmail    = "";
  String userPassword = "";
  String infoText     = "";
  bool   isLoading    = false;

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

  Future<UserCredential> signUp() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return auth.createUserWithEmailAndPassword(
        email:    userEmail,
        password: userPassword
    );
  }
}