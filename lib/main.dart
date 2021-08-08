import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy/widgets/black_hole.dart';
import 'package:galaxy/widgets/planet.dart';
import 'package:galaxy/widgets/sprinkle.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galaxy',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Planet> planets = [];
  final List<Sprinkle> sprinkles = [];
  late final Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
      setState(() {
        planets.add(Planet(
          key: UniqueKey(),
          onAnimationCompleted: (key) {
            setState(() {
              planets.removeWhere((element) => element.key == key);
            });
          },
          onTap: (shape, color, sizeFactor, offset) {
            setState(() {
              sprinkles.add(
                Sprinkle(
                  key: UniqueKey(),
                  onCompleteListener: (key) {
                    sprinkles.removeWhere((element) => element.key == key);
                  },
                  offset: offset,
                  color: color,
                  shape: shape,
                  sizeFactor: sizeFactor,
                ),
              );
            });
          },
        ));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ...planets,
          Center(
            child: BlackHole(),
          ),
          ...sprinkles,
        ],
      ),
    );
  }
}
