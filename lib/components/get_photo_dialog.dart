import 'dart:io';

import 'package:firebase_tutorial/components/error_dialog.dart';
import 'package:firebase_tutorial/repositories/fire_repository.dart';
import 'package:flutter/material.dart';

Future<File?> showGetPhotoDialog(
  BuildContext context, {
  String? newPhotoFilename,
  Widget? alertDialogContent,
}) async {
  return await showDialog<File>(
    context: context,
    builder: (context) {
      return GetPhotoDialog(
        newPhotoFilename: newPhotoFilename,
      );
    },
  );
}

class GetPhotoDialog extends StatelessWidget {
  /// Optionally overwrite the filename of a new photo taken with the camera
  final String? newPhotoFilename;
  final Widget? alertDialogContent;

  const GetPhotoDialog({
    Key? key,
    this.newPhotoFilename,
    this.alertDialogContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choose a photo"),
      content: alertDialogContent,
      actions: [
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("CAMERA"),
          onPressed: () => _takePhoto(context),
        ),
        TextButton(
          child: const Text("FILE"),
          onPressed: () => _chooseFile(context),
        ),
      ],
    );
  }

  void _takePhoto(BuildContext context) async {
    try {
      final fileRepository = FileRepository.of(context);
      final file = await fileRepository.takeNewPhoto(
        filename: newPhotoFilename,
      );

      Navigator.pop(context, file);
    } on FileRepositoryException catch (e) {
      Navigator.pop(context);
      showErrorDialog(context, e.message);
    }
  }

  void _chooseFile(BuildContext context) async {
    try {
      final fileRepository = FileRepository.of(context);
      final file = await fileRepository.pickPhoto();
      Navigator.pop(context, file);
    } on FileRepositoryException catch (e) {
      Navigator.pop(context);
      showErrorDialog(context, e.message);
    }
  }
}
