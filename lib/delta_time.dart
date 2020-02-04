import 'dart:ui';

import 'package:challenges/game_state.dart';
import 'package:challenges/mixins/setup_mixin.dart';
import 'package:flutter/material.dart';

class DeltaTime extends StatefulWidget {
  @override
  DeltaTimeState createState() => DeltaTimeState();
}

class DeltaTimeState extends State<DeltaTime>
    with SingleTickerProviderStateMixin, SetupMixin {
  bool _isInitialized = false;
  AnimationController _animationController;

  var gameState = GameState.menu;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    );

    _animationController.forward();

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
      appBar: AppBar(title: Text('DeltaTime')),
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, __) {
            return CustomPaint(
              key: customPaintKey,
              willChange: true,
              painter: _isInitialized
                  ? DeltaTimePainter(
                      _animationController,
                      this,
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }

  @override
  void onWindowResize(Size size) {}

  @override
  void setup(Size size) {
    // Work

    setState(() => _isInitialized = true);
  }
}

class DeltaTimePainter extends CustomPainter {
  DeltaTimePainter(this.animation, this.state)
      : brush = Paint()..color = Colors.white,
        _startTime = DateTime.now(),
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        super(repaint: animation);

  final Animation<double> animation;
  final Paint brush;
  DateTime _startTime;
  DateTime _endTime;
  TextStyle textStyle;
  DeltaTimeState state;

  @override
  void paint(Canvas canvas, Size size) {
    _endTime = DateTime.now();
    final deltaTime = _endTime.difference(_startTime);
    _startTime = _endTime;

    switch (state.gameState) {
      case GameState.menu:
        break;
      case GameState.playing:
        break;
      case GameState.lost:
        break;
      case GameState.won:
        break;
    }

    final textSpan = TextSpan(
      text: 'Delta Time (μ): ${deltaTime.inMicroseconds}',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(size.width - textPainter.size.width - 16.0, 16.0);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(DeltaTimePainter oldDelegate) {
    return true;
  }
}
