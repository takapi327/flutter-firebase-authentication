import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ErrorDialog extends StatelessWidget {
  final String? content;
  final String? title;
  final String? buttonText;

  ErrorDialog({this.title, this.buttonText, this.content});

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return AlertDialog(
        title: new Text(
          title ?? "",
        ),
        content: new Text(
          this.content ?? "",
        ),
        actions: <Widget>[
          new ElevatedButton(
            child: new Text(
              buttonText ?? "",
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
          title: Text(
            title ?? "",
          ),
          content: new Text(
            this.content ?? "",
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                this.buttonText ?? ""
                  /*
                buttonText[0].toUpperCase() +
                    buttonText.substring(1).toLowerCase(),
                   */
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]
      );
    }
  }
}
