import 'dart:io';

import 'package:flutter/material.dart';

class CircularFileImage extends StatelessWidget {
  final File? file;
  final double size;

  const CircularFileImage({
    Key? key,
    required this.file,
    this.size = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ClipOval(
        child: CircleAvatar(
          backgroundColor: Colors.grey[300],
          maxRadius: size / 2,
          child: Builder(
            builder: (context) {
              if (file != null) {
                return Image.file(
                  file!,
                  fit: BoxFit.cover,
                  height: size,
                  width: size,
                );
              }

              return const Icon(
                Icons.person,
                color: Colors.grey,
                size: 100,
              );
            },
          ),
        ),
      ),
    );
  }
}
