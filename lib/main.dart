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
            title: Text('Flutter Firebase Sign up Demo Home Page'),
            actions: [
              IconButton(
                icon:      Icon(Icons.account_circle_sharp),
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
                      Text('test'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
        /*
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Flutter Firebase Sign up Demo Home Page'),
      ),
      body: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.signOut();
                        setState(() {
                          infoText  = "ログアウト成功";
                          isLoading = false;
                        });
                      } catch (e) {
                        setState(() {
                          infoText  = "ログアウト失敗:${e.toString()}";
                          isLoading = false;
                        });
                      }
                    },
                    child: Text("ログアウト"),
                  ),
                  const SizedBox(height: 8),
                  Text(infoText),
                ],
              ),
            ),
            OverlayLoadingMolecules(visible: isLoading)
          ],
        ),
      ),
    );
         */
  }
}
