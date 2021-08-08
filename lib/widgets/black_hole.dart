import 'package:flutter/material.dart';

class BlackHole extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double radius = MediaQuery.of(context).size.height * 0.1;
    return CustomPaint(
      size: Size(
        radius * 2,
        radius * 2,
      ),
      painter: BlackHolePainter(radius: radius),
    );
  }
}

class BlackHolePainter extends CustomPainter {
  final double radius;

  BlackHolePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.black;
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
