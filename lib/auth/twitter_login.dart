import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_firebase_authentication/mvc/state/auth_store.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TwitterLogin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer <AuthStore>(
        builder: (context, authStore, _) {
          return NeumorphicButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.twitter,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Twitterでログイン',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              //padding: EdgeInsets.only(left: 8),
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.stadium(),
              ),
              onPressed: () {}
          );
        }
    );
  }
}
