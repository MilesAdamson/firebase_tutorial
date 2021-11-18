import 'dart:io';

import 'package:flutter/material.dart';

Future<File?> showErrorDialog(
  BuildContext context,
  String errorMessage,
) async {
  return await showDialog<File>(
    context: context,
    builder: (context) {
      return ErrorDialog(
        errorMessage: errorMessage,
      );
    },
  );
}

class ErrorDialog extends StatelessWidget {
  final String errorMessage;

  const ErrorDialog({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage),
      actions: [
        TextButton(
          child: const Text("DISMISS"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
