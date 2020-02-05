import 'package:challenges/shared/flutter_three/flutter_three.dart';
import 'package:flutter/material.dart';

class ObjFiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter 3D"),
      ),
      body: Center(
        child: FlutterThree(
          size: const Size(400.0, 400.0),
          path: "assets/dodecahedron.obj",
          asset: true,
        ),
      ),
    );
  }
}
