import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import "overlay_loading_molecules.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyAuthPage(),
    );
  }
}

class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  String newUserEmail      = "";
  String newUserPassword   = "";
  String infoText          = "";
  String loginUserEmail    = "";
  String loginUserPassword = "";
  bool   isLoading         = false;

  @override
  Widget build(BuildContext context) {
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
                  TextFormField(
                    decoration: InputDecoration(labelText: "メールアドレス"),
                    onChanged: (String value) {
                      setState(() {
                        newUserEmail = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(labelText: "パスワード(6文字以上)"),
                    obscureText: true,
                    onChanged: (String value) {
                      setState(() {
                        newUserPassword = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final UserCredential result = await auth.createUserWithEmailAndPassword(
                            email:    newUserEmail,
                            password: newUserPassword
                        );

                        final User user = result.user!;
                        setState(() {
                          infoText  = "登録OK:${user.toString()}";
                          isLoading = false;
                        });
                      } catch (e) {
                        setState(() {
                          infoText  = "登録NG:${e.toString()}";
                          isLoading = false;
                        });
                      }
                    },
                    child: Text("ユーザー登録"),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration: InputDecoration(labelText: "メールアドレス"),
                    onChanged: (String value) {
                      setState(() {
                        loginUserEmail = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "パスワード"),
                    onChanged: (String value) {
                      setState(() {
                        loginUserPassword = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final UserCredential result = await auth.signInWithEmailAndPassword(
                            email:    loginUserEmail,
                            password: loginUserPassword
                        );

                        final User user = result.user!;
                        setState(() {
                          infoText  = "ログインOK:${user.toString()}";
                          isLoading = false;
                        });
                      } catch (e) {
                        setState(() {
                          infoText  = "ログインNG:${e.toString()}";
                          isLoading = false;
                        });
                      }
                    },
                    child: Text("ログイン")
                  ),
                  const SizedBox(height: 32),
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
  }
}
