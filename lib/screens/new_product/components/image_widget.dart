import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? imagePath;
  final Function() onPickImage;

  const ImageWidget(
      {super.key, required this.imagePath, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return imagePath != null
        ? Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: Image.file(File(imagePath!),
                      height: 150.0, width: 150.0, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: onPickImage,
                        icon: const Icon(Icons.camera_alt_outlined)),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: Container(
                      color: Colors.white, height: 150.0, width: 150.0),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: onPickImage,
                        icon: const Icon(Icons.camera_alt_outlined)),
                  ),
                ),
              ],
            ),
          );
  }
}
