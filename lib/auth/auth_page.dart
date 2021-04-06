import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


import "package:flutter_firebase_authentication/overlay_loading_molecules.dart";

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';
import 'package:flutter_firebase_authentication/auth/signup.dart';

class AuthPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthStore>(
      builder: (context, authStore, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Authentication Page'),
          ),
          body: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      FirebaseAuthSignUp(),
                      const SizedBox(height: 8),
                      Text(authStore.infoText),
                    ],
                  ),
                ),
                OverlayLoadingMolecules(visible: authStore.isLoading)
              ],
            ),
          ),
        );
      },
    );
  }
}
