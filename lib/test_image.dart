import 'dart:io';

import 'package:colon_app/core/utlis/styles.dart';
import 'package:flutter/material.dart';

class ImageBox extends StatefulWidget {
  final File imagePath;
  final String clss;
  final double confidence;
  final Rect rect;

  const ImageBox({
    Key? key,
    required this.imagePath,
    required this.clss,
    required this.confidence,
    required this.rect,
  }) : super(key: key);

  @override
  _ImageBoxState createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'Class: ${widget.clss}',
            style: Styles.textStyle18,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '${'Confidence: ${widget.confidence * 100}'.substring(0, 17)}%',
            style: Styles.textStyle18,
          ),
          const SizedBox(
            height: 20,
          ),
          imageAfterPredict(),
        ],
      ),
    );
  }

  Center imageAfterPredict() {
    return Center(
      child: Stack(
        children: [
          Image.file(
            widget.imagePath,
            width: 350,
            height: 350,
            fit: BoxFit.fill,
          ),
          CustomPaint(
            painter: MyBoxPainter(widget.rect),
            size: widget.rect.size,
          ),
        ],
      ),
    );
  }
}

class MyBoxPainter extends CustomPainter {
  final Rect rect;

  MyBoxPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
