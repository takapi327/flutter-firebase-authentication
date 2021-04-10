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
  // This widget is the root of your application.
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
        //'/mypage':      (context) => MyPage(),
        '/mypage':      (context) => AuthGuard(MyPage()),
        //'/register/payment': (context) => Payment()
      },
    );
  }
}

class AuthGuard extends StatelessWidget {

  final Widget widget;

  @override
  AuthGuard(@required this.widget);

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthStore>(
      builder: (context, authStore, _) {

        void checkUser() async {
          final currentUser = await FirebaseAuth.instance.currentUser;
          if (currentUser == null) {
            Navigator.pushReplacementNamed(context, '/auth');
          }
        }

        checkUser();

        return widget;
      },
    );
  }
}

class TopPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthStore>(
      builder: (context, authStore, _) {
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text('トップページ'),
            actions: [
              if (FirebaseAuth.instance.currentUser != null)
              IconButton(
                icon:      Icon(Icons.account_circle_sharp),
                onPressed: () {
                  Navigator.pushNamed(context, '/mypage');
                }
              ),

              if (FirebaseAuth.instance.currentUser == null)
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
                      Text(FirebaseAuth.instance.currentUser.toString()),
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
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
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
                      if (FirebaseAuth.instance.currentUser!.displayName != null)
                        Text(FirebaseAuth.instance.currentUser!.displayName.toString()),
                      Text(FirebaseAuth.instance.currentUser!.email.toString()),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            await auth.signOut();
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
