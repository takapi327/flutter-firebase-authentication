import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_authentication/auth/login.dart';
import 'package:flutter_firebase_authentication/auth/signup.dart';
import 'package:provider/provider.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';
import 'auth/auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthStore()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/':            (context) => TopPage(),
        '/auth':        (context) => AuthPage(),
        '/auth/signup': (context) => FirebaseAuthSignUp(),
        '/auth/login':  (context) => FirebaseAuthLogIn(),
        '/mypage':      (context) => MyPage(),
        //'/mypage':      (context) => AuthGuard(MyPage()),
        //'/register/payment': (context) => Payment()
      },
    );
  }
}

/*
class AuthGuard extends StatelessWidget {

  final Widget widget;

  void checkUser(AuthStore authStore, BuildContext context) {
    if (authStore.currentUser == null) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  AuthGuard(@required this.widget);

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthStore>(
      builder: (context, authStore, _) {

        checkUser(authStore, context);

        return widget;
      },
    );
  }
}
 */

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
