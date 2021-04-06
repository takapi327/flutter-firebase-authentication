import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';

class FirebaseAuthLogIn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthStore>(
      builder: (context, authStore, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('ログイン'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "メールアドレス"),
                    onChanged: (String value) {
                      authStore.changeEmail(value);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(labelText: "パスワード(6文字以上)"),
                    obscureText: true,
                    onChanged: (String value) {
                      authStore.changePassword(value);
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        authStore.changeLoading(true);
                        final UserCredential result = await authStore.login();

                        final User user = result.user!;
                        authStore.changeInfoText("ログインOK:${user.toString()}");
                        authStore.authentication(user);
                        authStore.changeLoading(false);
                      } catch (e) {
                        authStore.changeInfoText("ログインNG:${e.toString()}");
                        authStore.changeLoading(false);
                      }
                    },
                    child: Text("ログイン"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
