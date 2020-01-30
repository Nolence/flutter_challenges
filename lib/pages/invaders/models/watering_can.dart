import 'dart:ui' as UI;

import 'package:challenges/utils/lerp_offset.dart';
import 'package:flutter/material.dart';

class WateringCan {
  WateringCan(
    this.position, {
    @required this.image,
    this.targetPosition,
    this.canSize = 40,
  });

  Offset position;
  final UI.Image image;
  Offset targetPosition;
  final double canSize;

  Rect get rect {
    return Rect.fromCenter(
      center: position,
      height: canSize,
      width: canSize,
    );
  }

  static Duration currentTime = Duration.zero;
  static const Duration updateRate = Duration(microseconds: 333333); // TODO:

  void show(Canvas canvas, Size size, Paint paint) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      rect,
      paint,
    );
  }

  void update(Duration deltaTime) {
    if (targetPosition != null) {
      position = lerpOffset(position, targetPosition, .1);
    }

    // currentTime += deltaTime;

    // if (currentTime > updateRate) {
    //   currentTime = Duration.zero;
    //   // lerpOffset(position, targetPosition, t);
    // }
  }
}
