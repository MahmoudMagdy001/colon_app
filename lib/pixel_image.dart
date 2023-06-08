import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageDisplay({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(imageBytes),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
