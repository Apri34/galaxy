import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Planet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double radius =
        MediaQuery.of(context).size.height * 0.02 * Random().nextInt(10);
    return CustomPaint(
      size: Size(
        radius * 2,
        radius * 2,
      ),
      painter: PlanetPainter(radius: radius),
    );
  }
}

class PlanetPainter extends CustomPainter {
  static const List<Color> colors = [
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.blue,
    Colors.red,
    Colors.cyan,
    Colors.deepPurple
  ];

  final double radius;

  PlanetPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = colors[Random().nextInt(colors.length - 1)];
    drawTriangle(canvas, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawCircle(Canvas canvas, Paint paint) {
    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }

  void drawRectangle(Canvas canvas, Paint paint) {
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: radius * 2, height: radius * 2),
        paint);
  }

  void drawTriangle(Canvas canvas, Paint paint) {
    Path path = Path();
    path.moveTo(radius * 2, radius * 2);
    path.lineTo(0, radius * 2);
    path.lineTo(radius, 0);
    path.close();
    canvas.drawPath(path, paint);
  }
}
