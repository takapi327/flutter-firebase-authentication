import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';

class MyPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthStore>(
      builder: (context, authStore, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('マイページ'),
          ),
          body: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Text(authStore.currentUser?.displayName?.toString() ?? "名前を登録していません"),
                      Text(authStore.currentUser?.email.toString() ?? "メールアドレスを登録指定ません"),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            await auth.signOut();
                            await authStore.setUser(null);
                            Navigator.of(context).pop();
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        child: Text("ログアウト"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
