import 'package:flutter/material.dart';

class CircularNetworkImage extends StatelessWidget {
  final String? url;
  final double size;

  const CircularNetworkImage({
    Key? key,
    required this.url,
    this.size = 200,
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
              if (url != null) {
                return Image.network(
                  url!,
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
