import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
//import 'package:flutter_firebase_authentication/overlay_loading_molecules.dart';
import './google_login.dart';
import './twitter_login.dart';
import './facebook_btn.dart';

class AuthPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer <AuthStore>(
      builder: (context, authStore, _) {
        return Scaffold(
          appBar: NeumorphicAppBar(
            title: Text('ログインページ'),
          ),
          body: Container(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  '',
                  style: TextStyle(
                    fontSize:   32,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Neumorphic(
                  style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.stadium(),
                      depth: -8
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.0),
                      labelText: "メールアドレス",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String value) {
                      authStore.changeEmail(value);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Neumorphic(
                  style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.stadium(),
                      depth: -8
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.0),
                      labelText: "パスワード(6文字以上)",
                      prefixIcon: Icon(
                        Icons.vpn_key_rounded,
                        color: Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    obscureText: true,
                    onChanged: (String value) {
                      authStore.changePassword(value);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                NeumorphicButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NeumorphicIcon(
                          Icons.lock,
                          style: NeumorphicStyle(
                              color: Colors.black54
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'ログイン',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.stadium(),
                    ),
                    padding: EdgeInsets.only(top: 12, left: 104, bottom: 12, right: 104),
                    onPressed: () async {
                      try {
                        authStore.changeLoading(true);
                        final UserCredential result = await authStore.login();
                        final User user = result.user!;

                        await authStore.setUser(user);
                        authStore.changeLoading(false);
                        Navigator.of(context).pop();
                      } catch (e) {
                        authStore.changeLoading(false);
                      }
                    }
                ),
                const SizedBox(height: 16),
                Text(
                  "- SNSでログイン -",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54
                  ),
                ),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 230),
                  child: GoogleLogin(),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 230),
                  child: TwitterLogin(),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 230),
                  child: FacebookLogin(),
                ),
                const SizedBox(height: 32),
                //OverlayLoadingMolecules(visible: authStore.isLoading)
              ],
            ),
          ),
        );
      },
    );
  }
}
