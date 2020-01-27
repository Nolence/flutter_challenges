import 'dart:ui';

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:flutter/material.dart';

class DeltaTime extends StatefulWidget {
  @override
  _DeltaTimeState createState() => _DeltaTimeState();
}

class _DeltaTimeState extends State<DeltaTime>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(days: 365),
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
              painter: DeltaTimePainter(_animationController.value),
              willChange: true,
            );
          },
        ),
      ),
    );
  }

  @override
  void onWindowResize(Size size) {}

  @override
  void setup(Size size) {}
}

class DeltaTimePainter extends CustomPainter {
  DeltaTimePainter(this.animationValue)
      : brush = Paint()..color = Colors.white,
        _startTime = DateTime.now(),
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 30,
        );

  final double animationValue;
  final Paint brush;
  DateTime _startTime;
  DateTime _endTime;
  TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    _endTime = DateTime.now();

    final deltaTime = _endTime.difference(_startTime);

    _startTime = _endTime;

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
    return animationValue != oldDelegate.animationValue;
  }
}
