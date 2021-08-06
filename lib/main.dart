import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:galaxy/widgets/black_hole.dart';
import 'package:galaxy/widgets/planet.dart';

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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: BlackHole(),
          ),
          Planet(),
        ],
      ),
    );
  }
}
