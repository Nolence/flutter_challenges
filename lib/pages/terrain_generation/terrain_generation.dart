import 'dart:math';
import 'dart:ui' as UI;

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show Vector2;
import 'package:vector_math/vector_math_lists.dart';

// https://kyorohiro.gitbooks.io/hello_skyengine/content/draw_vertices_1/doc/index.html

class TerrainGeneration extends StatefulWidget {
  @override
  TerrainGenerationState createState() => TerrainGenerationState();
}

class TerrainGenerationState extends State<TerrainGeneration>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;
  bool _isInitialized = false;

  int columns, rows;
  double scale = 40.0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    );

    // _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(title: Text('Terrain Generation')),
        body: SizedBox.expand(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, __) {
              return CustomPaint(
                key: customPaintKey,
                willChange: true,
                painter: _isInitialized
                    ? TerrainGenerationPainter(_animationController, this)
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void onWindowResize(Size size) {}

  @override
  void setup(Size size) {
    columns = (size.width / scale).round();
    rows = (size.height / scale).round();

    setState(() => _isInitialized = true);
  }
}

class TerrainGenerationPainter extends CustomPainter {
  const TerrainGenerationPainter(this.animation, this.state)
      : super(repaint: animation);

  final Animation<double> animation;
  final TerrainGenerationState state;

  @override
  void paint(Canvas canvas, Size size) {
    final brush = Paint();
    final scale = state.scale;

    // final perspectiveMatrix = makePerspectiveMatrix(pi / 2, 1, 200, 800)
    //   ..rotateX(-pi / 3);

    final perspectiveMatrix = _pmat(1.5)..rotateX(-pi / 3);

    canvas.translate(size.width / 2, size.height / 1.5);
    canvas.transform(perspectiveMatrix.storage);
    canvas.translate(-size.width / 2, -size.height / 2);

    final List<Vector2List> allVertices = [];

    // final vector3List = Vector3List(10);

    // vector3List.add(0, Vector3(100, 100, 5));
    // print(vector3List.buffer);
    // vector3List.add(1, Vector3(200, 300, 400));
    // print(vector3List.buffer);

    // canvas.drawVertices(
    //   UI.Vertices.raw(
    //     VertexMode.triangleStrip,
    //     vector3List.buffer,
    //   ),
    //   BlendMode.srcATop,
    //   brush,
    // );

    for (int i = 0; i < state.rows; i++) {
      allVertices.add(Vector2List(state.columns));
      // allVertices.add(Vector3List(state.rows));

      for (int j = 0; j < state.columns; j++) {
        // for (int j = 0; j < state.columns + 1; j++) {
        final vector3List = allVertices[i];

        vector3List.add(j, Vector2(j * scale, i * scale));
        vector3List.add(j, Vector2(j * scale, (i + 1) * scale));
      }
    }

    for (final vectorList in allVertices) {
      canvas.drawVertices(
        UI.Vertices.raw(
          VertexMode.triangleStrip,
          vectorList.buffer,
        ),
        // UI.Vertices(
        //   VertexMode.triangleStrip,
        //   points,
        // ),
        BlendMode.srcATop,
        brush,
      );
    }
  }

  static Matrix4 _pmat(num pv) {
    return Matrix4(
      1.0, 0.0, 0.0, 0.0, //
      0.0, 1.0, 0.0, 0.0, //
      0.0, 0.0, 1.0, pv * 0.001, //
      0.0, 0.0, 0.0, 1.0,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// colors: List.generate(
//     points.length, (_) => Color(Random().nextInt(0xffffffff))),
