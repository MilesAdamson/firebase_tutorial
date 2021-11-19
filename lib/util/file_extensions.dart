import 'dart:io';

extension FileExtensions on File {
  String get extension => path.split(".").last;

  String get filename => path.split("/").last;
}
