import 'dart:io';

extension FileExtensions on File {
  static const acceptedImageFormats = [
    "png",
    "jpg",
    "jpeg",
  ];

  bool isAcceptedImageFormat() => acceptedImageFormats.contains(extension);

  String get extension => path.split(".").last;

  String get filename => path.split("/").last;
}
