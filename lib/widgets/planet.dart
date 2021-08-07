import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Planet extends StatefulWidget {

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
    duration: Duration(seconds: 2),
    vsync: this,
  )..forward()..addStatusListener((status) {
    //TODO remove widget
  });

  late final _Form form;
  late final _Position position;
  late final int sizeFactor;
  late final Color color;
  double radius = 0.0;
  late Animation<double> animation;
  late final double xPosition;
  late final double yPosition;

  @override
  void initState() {
    form = getRandomForm();
    position = getRandomPosition();
    sizeFactor = Random().nextInt(10);
    color = colors[Random().nextInt(colors.length)];
    xPosition = Random().nextDouble();
    yPosition = Random().nextDouble();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final initialRadius = height * 0.02 * sizeFactor;

    final double xStartPoint = position == _Position.LEFT
        ? -initialRadius * 2
        : position == _Position.RIGHT
            ? width
            : xPosition * width;
    final double yStartPoint = position == _Position.TOP
        ? -initialRadius * 2
        : position == _Position.BOTTOM
            ? height
            : yPosition * height;

    animation = Tween<double>(begin: initialRadius, end: 0)
        .animate(_controller)
          ..addListener(() {
            setState(() {
              radius = animation.value;
            });
          });

    return PositionedTransition(
      rect: RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          xStartPoint,
          yStartPoint,
          xStartPoint + initialRadius * 2,
          yStartPoint + initialRadius * 2,
        ),
        end: RelativeRect.fromLTRB(
          width / 2,
          height / 2,
          width / 2,
          height / 2,
        ),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ),
      ),
      child: CustomPaint(
        size: Size(
          radius * 2,
          radius * 2,
        ),
        painter: PlanetPainter(
          radius: radius,
          color: color,
          form: form,
        ),
      ),
    );
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
