// ref https://felixblaschke.medium.com/fancy-background-animations-in-flutter-4163d50f5c37

import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedWave extends AnimatedWidget {
  final double height;
  final double offset;
  final double? pageOffset;
  final Color color;

  const AnimatedWave(
      {Key? key,
      required Animation<double> animation,
      required this.height,
      this.offset = 0.0,
      this.pageOffset,
      this.color = Colors.white12})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return LayoutBuilder(builder: (context, constraints) {
      // ignore: sized_box_for_whitespace
      return Container(
          height: height,
          width: constraints.biggest.width,
          child: CustomPaint(
            foregroundPainter: CurvePainter(
                (animation.value + (pageOffset ?? 0) * 2) + offset, color),
          ));
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;
  Color color;

  CurvePainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = color;
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
