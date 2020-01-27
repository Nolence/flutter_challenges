import 'package:flutter/material.dart';

class Snake {
  Snake(
    this.position,
    this.direction, {
    this.height,
    this.width,
  }) : speed = 1.0;

  Offset position;
  Offset direction;
  final double speed;
  final double height;
  final double width;

  void show(Canvas canvas, Paint paint, Size size) {
    paint = paint..color = Colors.greenAccent;

    canvas.drawRect(
      Rect.fromLTWH(position.dx, position.dy, width, height),
      paint,
    );
  }

  void update() {
    // This won't work
    position += direction * (speed * width);
  }
}
