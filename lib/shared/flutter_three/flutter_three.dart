import 'dart:io';
import 'dart:ui';

import 'package:challenges/shared/flutter_three/parsers/obj_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:vector_math/vector_math.dart' show Vector3;
import 'package:vector_math/vector_math.dart' as V;

// FIXME: Scrolling diagonally needs to be sped up

class FlutterThree extends StatefulWidget {
  const FlutterThree({
    @required this.size,
    @required this.path,
    @required this.asset,
    this.angleX,
    this.angleY,
    this.angleZ,
    this.zoom = 100.0,
  });

  final Size size;
  final bool asset;
  final String path;
  final double zoom;
  final double angleX;
  final double angleY;
  final double angleZ;

  @override
  _Object3DState createState() => _Object3DState();
}

class _Object3DState extends State<FlutterThree> {
  bool useInternal;

  double angleX = 15.0;
  double angleY = 45.0;
  double angleZ = 0.0;

  double _previousX = 0.0;
  double _previousY = 0.0;

  double zoom;

  SimpleGeometry geometry;

  void initState() {
    if (widget.asset == true) {
      // TODO: PR: Stream the data and work on it line by line with yeilds, etc.
      // rootBundle.load(key)
      rootBundle.loadString(widget.path).then((String value) {
        setState(() => geometry = parseObjString(value));
      });
    } else {
      File file = File(widget.path);
      file.readAsString().then((String value) {
        setState(() => geometry = parseObjString(value));
      });
    }

    useInternal = !(widget.angleX != null ||
        widget.angleY != null ||
        widget.angleZ != null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (data) => _updateCube(data),
      onVerticalDragUpdate: (data) => _updateCube(data),
      child: CustomPaint(
        size: widget.size,
        willChange: true,
        painter: _ObjectPainter(
          widget.size,
          geometry,
          useInternal ? angleX : widget.angleX,
          useInternal ? angleY : widget.angleY,
          useInternal ? angleZ : widget.angleZ,
          widget.zoom,
        ),
      ),
    );
  }

  void _updateCube(DragUpdateDetails data) {
    // Handle rotation
    if (angleY > 360.0) {
      angleY = angleY - 360.0;
    }
    if (_previousY > data.globalPosition.dx) {
      setState(() => angleY = angleY - 1);
    }
    if (_previousY < data.globalPosition.dx) {
      setState(() => angleY = angleY + 1);
    }

    _previousY = data.globalPosition.dx;

    if (angleX > 360.0) {
      angleX = angleX - 360.0;
    }

    if (_previousX > data.globalPosition.dy) {
      setState(() => angleX = angleX - 1);
    }
    if (_previousX < data.globalPosition.dy) {
      setState(() => angleX = angleX + 1);
    }

    _previousX = data.globalPosition.dy;
  }
}

class _ObjectPainter extends CustomPainter {
  _ObjectPainter(
    this.size,
    this.geometry,
    this.angleX,
    this.angleY,
    this.angleZ,
    this._zoomFactor,
  ) {
    // camera = Vector3(0.0, 0.0, 0.0); // TODO: PR Remove this
    // TODO: PR to add this as an argument
    // Right now, light gets normalized. There isn't any idea of a point light
    light = Vector3(0.0, 0.0, 1.0);
    color = Color.fromARGB(255, 255, 255, 255);
    _viewPortX = (size.width / 2).toDouble();
    _viewPortY = (size.height / 2).toDouble();
  }

  // final double _rotation = 5.0; // in degrees
  // final double _scalingFactor = 10.0 / 100.0; // in percent

  final SimpleGeometry geometry;

  double _zoomFactor = 100.0;
  double _viewPortX = 0.0, _viewPortY = 0.0;

  List<Vector3> vertices;
  List<dynamic> faces;
  V.Matrix4 T;
  // Vector3 camera;
  Vector3 light;

  double angleX;
  double angleY;
  double angleZ;

  Color color;

  Size size;

  @override
  void paint(Canvas canvas, Size size) {
    final vertices = geometry.vertices;
    final List<List<int>> faces = geometry.faces;

    // Pretty much make a copy of vertices verticesToDraw = [...vertices]
    final verticesToDraw = <Vector3>[];
    vertices.forEach((vertex) {
      verticesToDraw.add(Vector3.copy(vertex));
    });

    // Apply screen transformations to vertices
    for (int i = 0; i < verticesToDraw.length; i++) {
      verticesToDraw[i] = _calcDefaultVertex(verticesToDraw[i]);
    }

    // For every face, calculate the the sum of the lengths
    // of every vertex in the z-direction.

    final sumOfZ = <Map>[]; // TODO: PR. Rename avg to sum
    for (int i = 0; i < faces.length; i++) {
      List<num> face = faces[i];
      double z = 0.0;

      face.forEach((num x) {
        z += verticesToDraw[x.toInt() - 1].z;
      });

      Map data = <String, num>{
        "index": i,
        "z": z,
      };

      sumOfZ.add(data);
    }

    //  Sort the faces indices from largest z-components to smallest
    sumOfZ.sort((Map a, Map b) => a['z'].compareTo(b['z']));

    for (int i = 0; i < faces.length; i++) {
      List face = faces[sumOfZ[i]["index"]];

      // TODO: PR: Add camera functionality
      // if (_shouldDrawFace(face)) {
      final List<dynamic> faceProp = _drawFace(verticesToDraw, face);
      canvas.drawPath(faceProp[0], faceProp[1]);
      // }
    }
  }

  @override
  bool shouldRepaint(_ObjectPainter old) =>
      old.geometry != geometry ||
      old.angleX != angleX ||
      old.angleY != angleY ||
      old.angleZ != angleZ ||
      old._zoomFactor != _zoomFactor;

  // TODO: Add to widget initState
  /// Have this open for reference:
  /// https://people.cs.clemson.edu/~dhouse/courses/405/docs/brief-obj-file-format.html

  // bool _shouldDrawFace(List face) {
  //   final normalVector = _normalVector3(
  //     vertices[face[0] - 1],
  //     vertices[face[1] - 1],
  //     vertices[face[2] - 1],
  //   );
  //   final dotProduct = normalVector.dot(camera);
  //   final vectorLengths = normalVector.length * camera.length;
  //   final angleBetween = dotProduct / vectorLengths;

  //   return angleBetween < 0;
  // }

  /// For triangles, it is easy: one takes two of the triangle's edges and calculates the cross product:
  Vector3 _normalVector3(Vector3 first, Vector3 second, Vector3 third) {
    // TODO: Test to see if this works: final secondFirst = second..sub(first);
    Vector3 secondFirst = Vector3.copy(second);
    secondFirst.sub(first);
    Vector3 secondThird = Vector3.copy(second);
    secondThird.sub(third);

    return secondFirst.cross(secondThird).normalized();

    // return Vector3(
    //   (secondFirst.y * secondThird.z) - (secondFirst.z * secondThird.y),
    //   (secondFirst.z * secondThird.x) - (secondFirst.x * secondThird.z),
    //   (secondFirst.x * secondThird.y) - (secondFirst.y * secondThird.x),
    // );
  }

  double _scalarMultiplication(Vector3 first, Vector3 second) {
    return (first.x * second.x) + (first.y * second.y) + (first.z * second.z);
  }

  /// returns transformed vertex to match rotation/screen zoom/translation.
  Vector3 _calcDefaultVertex(Vector3 vertex) {
    // Get transformation matrix
    T = V.Matrix4.translationValues(_viewPortX, _viewPortY, 0);
    // zoom matrix
    T.scale(_zoomFactor, -_zoomFactor);

    // Rotate Matrix
    T.rotateX(V.radians(angleX != null ? angleX : 0.0));
    T.rotateY(V.radians(angleY != null ? angleY : 0.0));
    T.rotateZ(V.radians(angleZ != null ? angleZ : 0.0));

    return T.transform3(vertex);
  }

  List<dynamic> _drawFace(List<Vector3> verticesToDraw, List face) {
    final result = List<dynamic>(2);
    final paint = Paint();
    final path = Path();

    final normalizedLight = Vector3.copy(light).normalized();
    final normalVector = _normalVector3(
      verticesToDraw[face[0] - 1],
      verticesToDraw[face[1] - 1],
      verticesToDraw[face[2] - 1],
    );

    var koef = _scalarMultiplication(normalVector, normalizedLight);

    if (koef < 0.0) koef = 0.0;

    var newColor = Color.fromARGB(255, 0, 0, 0);

    newColor = newColor.withRed((color.red.toDouble() * koef).round());
    newColor = newColor.withGreen((color.green.toDouble() * koef).round());
    newColor = newColor.withBlue((color.blue.toDouble() * koef).round());

    paint.color = newColor;
    paint.style = PaintingStyle.fill;

    double firstVertexX, firstVertexY, secondVertexX, secondVertexY;

    for (int i = 0; i < face.length; i++) {
      firstVertexX = verticesToDraw[face[i] - 1][0].toDouble();
      firstVertexY = verticesToDraw[face[i] - 1][1].toDouble();
      secondVertexX = verticesToDraw[face[i] - 1][0].toDouble();
      secondVertexY = verticesToDraw[face[i] - 1][1].toDouble();

      if (i == 0) {
        path.moveTo(firstVertexX, firstVertexY);
      }

      path.lineTo(secondVertexX, secondVertexY);
    }

    path.close();
    result[0] = path;
    result[1] = paint;

    return result;
  }
}
