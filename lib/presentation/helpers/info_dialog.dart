import 'dart:async';

import 'package:flutter/material.dart';

Future<void> showInfoDialog(BuildContext context,
    {String title = "", String message = "", int delay = 1000}) async {
  await showDialog<void>(
    barrierColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      Timer(Duration(milliseconds: delay), () {
        Navigator.of(context).pop();
      });
      return AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.7),
        title: Center(
            child: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Colors.white,
              ),
        )),
        content: message != '' ? Text(message) : null,
      );
    },
  );
}
