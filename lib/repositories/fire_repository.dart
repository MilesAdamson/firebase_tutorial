import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_tutorial/repositories/firebase_providers.dart';
import 'package:firebase_tutorial/util/file_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileRepository {
  final FirebaseStorageProvider _storageProvider;
  final ImagePicker _imagePicker;

  FirebaseStorage get _cloudStorage => _storageProvider();

  FileRepository(this._imagePicker, this._storageProvider);

  static FileRepository of(BuildContext context) =>
      RepositoryProvider.of<FileRepository>(context);

  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowedExtensions: allowedExtensions,
      );

      final path = result?.files.single.path;

      if (path == null) return null;

      final file = File(path);

      // Some operating systems do not respect the allowedExtensions
      // and let the user pick anything, so we need to double check
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
      pickFile(allowedExtensions: FileExtensions.acceptedImageFormats);

  Future<File?> takeNewPhoto(
    String filename, {
    int imageQuality = 100,
  }) async {
    assert(!filename.contains("."),
        "Do not include the extension in the desired filename");

    try {
      final result = await _imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: imageQuality);

      if (result == null) return null;

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

  Future<File> download(String folderId, String filePath) async {
    assert(filePath.split(".").length == 2,
        "Include the extension in the filepath");

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filePath');
      await _cloudStorage.ref(folderId).child(filePath).writeToFile(file);
      return file;
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

  Future<Reference?> searchFolder(String folderId, String filePath) async {
    assert(filePath.split(".").length == 2,
        "Include the extension in the filepath");

    try {
      final refs = await getReferencesInFolder(folderId);
      return refs.firstWhereOrNull((ref) => ref.fullPath.contains(filePath));
    } catch (e, s) {
      debugPrint("$e\n$s");
      throw FileRepositoryException("An unknown error occurred");
    }
  }
}

class FileRepositoryException {
  final String message;

  FileRepositoryException(this.message);
}