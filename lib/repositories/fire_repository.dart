import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_tutorial/repositories/firebase_providers.dart';
import 'package:firebase_tutorial/util/file_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileRepository {
  static const acceptedImageFormats = [
    "png",
    "jpg",
    "jpeg",
  ];

  final FirebaseStorageProvider _storageProvider;
  final ImagePicker _imagePicker;

  FirebaseStorage get _cloudStorage => _storageProvider();

  FileRepository(this._imagePicker, this._storageProvider);

  static FileRepository of(BuildContext context) =>
      RepositoryProvider.of<FileRepository>(context);

  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        // Some devices do not respect the allowedExtensions
        allowedExtensions: allowedExtensions,
        // You must put FileType.custom for type if you provide allowedExtensions
        type: [allowedExtensions ?? []].isNotEmpty
            ? FileType.custom
            : FileType.any,
      );

      final path = result?.files.single.path;

      if (path == null) return null;

      final file = File(path);

      // Double check extension to ensure it was the correct type of file
      if (allowedExtensions != null &&
          !allowedExtensions.contains(file.extension)) {
        throw FileRepositoryException(
            "Files of the type ${file.extension} are not allowed here");
      }

      return file;
    } catch (e, s) {
      debugPrint("$e\n$s");
      throw FileRepositoryException("An unknown error occurred");
    }
  }

  Future<File?> pickPhoto() =>
      pickFile(allowedExtensions: acceptedImageFormats);

  Future<File?> takeNewPhoto({
    String? filename,
    int imageQuality = 100,
  }) async {
    assert(filename == null || !filename.contains("."),
        "Do not include the extension in the desired filename");

    try {
      final result = await _imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: imageQuality);

      if (result == null) return null;

      filename ??= const Uuid().v4();

      final ext = result.path.split(".").last;
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filename.$ext';
      await result.saveTo(path);

      return File(path);
    } catch (e, s) {
      debugPrint("$e\n$s");
      throw FileRepositoryException("An unknown error occurred");
    }
  }

  Future<Reference> upload(String folderId, File file) async {
    try {
      final taskSnapshot =
          await _cloudStorage.ref(folderId).child(file.filename).putFile(file);
      return taskSnapshot.ref;
    } catch (e, s) {
      debugPrint("$e\n$s");
      throw FileRepositoryException("An unknown error occurred");
    }
  }

  Future<void> delete(String fullPath) async {
    try {
      await _cloudStorage.ref(fullPath).delete();
    } catch (e, s) {
      debugPrint("$e\n$s");
      throw FileRepositoryException("An unknown error occurred");
    }
  }

  Future<List<Reference>> getReferencesInFolder(String folderId) async {
    try {
      final listResult = await _cloudStorage.ref(folderId).listAll();
      return listResult.items;
    } catch (e, s) {
      debugPrint("$e\n$s");
      throw FileRepositoryException("An unknown error occurred");
    }
  }

  Future<String> getDownloadUrlFromFullPath(String path) =>
      _cloudStorage.ref(path).getDownloadURL();
}

class FileRepositoryException {
  final String message;

  FileRepositoryException(this.message);
}
