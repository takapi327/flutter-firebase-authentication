import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';

class AuthPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthStore>(
      builder: (context, authStore, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Authentication Page'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child:     Text('Sign Up'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth/signup');
                  }
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child:     Text('Log In'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth/login');
                  }
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
