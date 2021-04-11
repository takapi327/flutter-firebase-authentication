import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';

class TopPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthStore>(
      builder: (context, authStore, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('トップページ'),
            actions: [
              if (authStore.currentUser != null)
                IconButton(
                    icon:      Icon(Icons.account_circle_sharp),
                    onPressed: () {
                      Navigator.pushNamed(context, '/mypage');
                    }
                ),

              if (authStore.currentUser == null)
                IconButton(
                    icon:      Icon(Icons.login),
                    onPressed: () {
                      Navigator.pushNamed(context, '/auth');
                    }
                ),
            ],
          ),
          body: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      if (authStore.currentUser != null)
                        Text(authStore.currentUser.toString()),
                      if (authStore.currentUser == null)
                        Text("未ログイン"),
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