import 'dart:ui';

import 'package:flutter/material.dart';

class Sketcher extends CustomPainter {
  final double progress;

  final Color color;
  final Offset p1;
  final Offset p2;

  Sketcher({required this.p1, required this.p2, required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    paint.strokeCap = StrokeCap.round;
    // paint.strokeJoin = StrokeJoin.round;
    paint.strokeWidth = 5;
    canvas.drawLine(p1, Offset(lerpDouble(p1.dx, p2.dx, progress)!, lerpDouble(p1.dy, p2.dy, progress)!), paint);
  }

  @override
  bool shouldRepaint(covariant Sketcher oldDelegate) {
    return true;
  }
}

class SketcherRealtime extends CustomPainter {
  final List<Offset> points;
  final Color freeLineColor;

  SketcherRealtime(this.points, this.freeLineColor);

  @override
  bool shouldRepaint(SketcherRealtime oldDelegate) {
    return oldDelegate.points != points;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = freeLineColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }
}
