import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Planet extends StatefulWidget {
  final Function(Key? key) onAnimationCompleted;

  const Planet({Key? key, required this.onAnimationCompleted})
      : super(key: key);

  @override
  _PlanetState createState() => _PlanetState();
}

class _PlanetState extends State<Planet> with SingleTickerProviderStateMixin {
  static const List<Color> colors = [
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.blue,
    Colors.red,
    Colors.cyan,
    Colors.deepPurple
  ];

  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 20 + Random().nextInt(10)),
    vsync: this,
  )
    ..forward()
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationCompleted(widget.key);
      }
    });

  late final _Form form;
  late final int sizeFactor;
  late final Color color;
  late final double initialAngle;
  double planetRadius = .0;
  double orbitRadius = 0.0;
  double angle = 0.0;
  late Animation<double> radiusAnimation;
  late Animation<double> angleAnimation;

  @override
  void initState() {
    form = getRandomForm();
    sizeFactor = Random().nextInt(10);
    initialAngle = Random().nextDouble() * pi * 2;
    color = colors[Random().nextInt(colors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final initialPlanetRadius = height * 0.015 * sizeFactor;
    final initialOrbitRadius = height / 2 + initialPlanetRadius;

    radiusAnimation = Tween<double>(begin: 1, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          planetRadius = initialPlanetRadius * radiusAnimation.value;
          orbitRadius = initialOrbitRadius * radiusAnimation.value;
        });
      });

    angleAnimation = Tween<double>(
      begin: 0,
      end: pi * 16,
    ).animate(_controller)
      ..addListener(() {
        setState(() {
          angle = initialAngle + angleAnimation.value;
        });
      });

    return Positioned(
      left: width / 2 + sin(pi/2 - angle) * orbitRadius - planetRadius,
      top: height / 2 + sin(angle) * orbitRadius - planetRadius,
      width: planetRadius * 2,
      height: planetRadius * 2,
      child: CustomPaint(
        size: Size(
          planetRadius * 2,
          planetRadius * 2,
        ),
        painter: PlanetPainter(
          radius: planetRadius,
          color: color,
          form: form,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _Form getRandomForm() {
    return _Form.values[Random().nextInt(_Form.values.length)];
  }

  _Position getRandomPosition() {
    return _Position.values[Random().nextInt(_Position.values.length)];
  }
}

class PlanetPainter extends CustomPainter {
  final double radius;
  final Color color;
  final _Form form;

  PlanetPainter(
      {required this.radius, required this.color, required this.form});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    switch (form) {
      case _Form.TRIANGLE:
        drawTriangle(canvas, paint);
        break;
      case _Form.RECTANGLE:
        drawRectangle(canvas, paint);
        break;
      case _Form.CIRCLE:
        drawCircle(canvas, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawCircle(Canvas canvas, Paint paint) {
    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }

  void drawRectangle(Canvas canvas, Paint paint) {
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(radius, radius),
            width: radius * 2,
            height: radius * 2),
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

enum _Form { TRIANGLE, RECTANGLE, CIRCLE }

enum _Position { TOP, BOTTOM, RIGHT, LEFT }
