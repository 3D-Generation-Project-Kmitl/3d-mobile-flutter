import 'dart:async';

import 'package:flutter/material.dart';

Future<void> showConfirmDialog(BuildContext context,
    {String title = "",
    String message = "",
    required Function onConfirm}) async {
  await showDialog<void>(
    barrierColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.7),
        title: Center(
            child: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Colors.white,
              ),
        )),
        content: message != ''
            ? Text(message,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Colors.white,
                    ))
            : null,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'ยกเลิก',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(
              'ตกลง',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      );
    },
  );
}
