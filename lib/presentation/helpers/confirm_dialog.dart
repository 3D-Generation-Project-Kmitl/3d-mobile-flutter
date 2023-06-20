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
        contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
        title: Text(title, style: Theme.of(context).textTheme.headline4),
        content: message != ''
            ? Text(message, style: Theme.of(context).textTheme.bodyText2)
            : null,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'ยกเลิก',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.grey[600],
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
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
        ],
      );
    },
  );
}
