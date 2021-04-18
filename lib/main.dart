import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_authentication/auth/login.dart';
import 'package:flutter_firebase_authentication/auth/signup.dart';
import 'package:provider/provider.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';
import 'package:flutter_firebase_authentication/mvc/state/stripe_store.dart';
import 'auth/auth_page.dart';
import 'top_page.dart';
import 'mypage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthStore()),
        ChangeNotifierProvider(create: (context) => StripeStore()),
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
        //'/register/payment': (context) => PaymentMethods()
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
