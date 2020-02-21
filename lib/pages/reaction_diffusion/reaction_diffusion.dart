import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReactionDiffusion extends StatefulWidget {
  @override
  ReactionDiffusionState createState() => ReactionDiffusionState();
}

class ReactionDiffusionState extends State<ReactionDiffusion>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  ReactionDiffusionPainter painter;
  final customPaintKey = GlobalKey();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        days: 365, // Large durations sometimes breaks android.
      ),
    );

    Future.delayed(Duration.zero, () {
      final context = customPaintKey.currentContext;
      final RenderBox box = context.findRenderObject();

      setState(() {
        painter = ReactionDiffusionPainter(_animationController, box.size);
      });

      // _animationController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ReactionDiffusion')),
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, __) {
            return CustomPaint(
              key: customPaintKey,
              painter: painter,
            );
          },
        ),
      ),
    );
  }
}

class Cell {
  const Cell({this.a, this.b});

  final int a;
  final int b;
}

class ReactionDiffusionPainter extends CustomPainter {
  ReactionDiffusionPainter(this.animation, this.size)
      : grid = List.generate(
          size.width.toInt(),
          (index) => List<Cell>(size.height.toInt()),
        ),
        next = List.generate(
          size.width.toInt(),
          (index) => List<Cell>(size.height.toInt()),
        ),
        super(repaint: animation) {
    for (int x = 0; x < grid.length; x++) {
      for (int y = 0; y < grid[0].length; y++) {
        grid[x][y] = Cell(a: 0, b: 0);
        grid[x][y] = Cell(a: 0, b: 0);
      }
    }
  }

  final Animation<double> animation;
  final Size size;

  final List<List<Cell>> grid;
  final List<List<Cell>> next;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width.toInt();
    final height = size.height.toInt();

    for (int x = 0; x < grid.length; x++) {
      // for (int y = 0; y < grid[0].length; y++) {
      canvas.drawVertices(
        UI.Vertices(
          UI.VertexMode.triangles,
          grid[0]
              .map<Offset>(
                (cell) => Offset(cell.a.toDouble(), cell.b.toDouble()),
              )
              .toList(),
        ),
        BlendMode.srcATop,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2,
      );
    }
    // }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
