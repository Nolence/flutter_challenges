import 'dart:ui';
import 'dart:ui' as UI;

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:challenges/pages/invaders/levels.dart';
import 'package:challenges/pages/invaders/models/flower.dart';
import 'package:challenges/pages/invaders/models/water_drop.dart';
import 'package:challenges/pages/invaders/models/watering_can.dart';
import 'package:challenges/utils/load_ui_image.dart';
import 'package:challenges/utils/throttler.dart';
import 'package:flutter/material.dart';

class Invaders extends StatefulWidget {
  @override
  _InvadersState createState() => _InvadersState();
}

class _InvadersState extends State<Invaders>
    with SingleTickerProviderStateMixin, SetupMixin {
  bool isInitialized = false;
  AnimationController _animationController;
  List<Flower> flowers = [];
  List<WaterDrop> waterDrops = [];
  WateringCan wateringCan;
  UI.Image waterDropImage;
  final throttle = Throttler(duration: Duration(milliseconds: 150));

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
      appBar: AppBar(title: Text('Invaders')),
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            // Image.network(
            //   'http://clipart-library.com/images/6Tr5Ej4pc.jpg',
            //   fit: BoxFit.cover,
            // ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, __) {
                return CustomPaint(
                  key: customPaintKey,
                  painter: isInitialized
                      ? InvadersPainter(
                          _animationController,
                          wateringCan: wateringCan,
                          flowers: flowers,
                          waterDrops: waterDrops,
                        )
                      : null,
                  willChange: true,
                );
              },
            ),
            GestureDetector(
              onPanUpdate: _move,
              onTapDown: _onShoot,
              onPanEnd: _stopMoving,
            ),
          ],
        ),
      ),
    );
  }

  void _move(DragUpdateDetails details) {
    wateringCan.targetPosition = details.localPosition;

    _shoot(wateringCan.position);
  }

  void _stopMoving(DragEndDetails details) {}

  void _onShoot(TapDownDetails details) {
    wateringCan.targetPosition = details.localPosition;

    _shoot(wateringCan.position);
  }

  void _shoot(Offset position) {
    throttle.throttle(
      () {
        waterDrops.add(
          WaterDrop(
            position.translate(
              wateringCan.canSize / 2 - 8.0,
              -wateringCan.canSize / 2 - 6.0,
            ),
            image: waterDropImage,
          ),
        );
      },
    );
  }

  @override
  void onWindowResize(Size size) {}

  @override
  void setup(Size size) async {
    final images = await Future.wait([
      loadUiImage('assets/watering_can.png'),
      loadUiImage('assets/flower_1.png'),
      loadUiImage('assets/flower_2.png'),
      loadUiImage('assets/flower_3.png'),
      loadUiImage('assets/water_drop.png'),
    ]);

    final wateringCanImage = images.first;
    final flowerImages = images.getRange(1, 3).toList();
    waterDropImage = images[4];

    final position = Offset(size.width / 2, size.height - 100);
    wateringCan = WateringCan(position, image: wateringCanImage);

    final flowerSize = 30.0;
    final level = levels.last;

    for (int i = 0; i < level.rows; i++) {
      for (int j = 0; j < level.columns; j++) {
        final flowerLevel = level.arrangement[i][j];
        if (flowerLevel == null) continue;
        UI.Image image;

        switch (flowerLevel) {
          case Fl.e:
            image = flowerImages[0];
            break;
          case Fl.m:
            image = flowerImages[1];
            break;
          case Fl.h:
            image = flowerImages[2];
            break;
        }

        final position = Offset(
          30.0 + (j * (level.gap + flowerSize)),
          100.0 + (i * 100),
        );

        flowers.add(Flower(
          position,
          flowerSize,
          image,
          flowerLevel,
        ));
      }
    }

    setState(() => isInitialized = true);
  }
}

class InvadersPainter extends CustomPainter {
  InvadersPainter(
    this.animation, {
    @required this.wateringCan,
    @required this.flowers,
    @required this.waterDrops,
  })  : brush = Paint()..color = Colors.white,
        _startTime = DateTime.now(),
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        super(repaint: animation);

  final Animation<double> animation;
  final Paint brush;
  final WateringCan wateringCan;
  final List<Flower> flowers;
  final List<WaterDrop> waterDrops;

  DateTime _startTime;
  DateTime _endTime;
  TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    _endTime = DateTime.now();
    final deltaTime = _endTime.difference(_startTime);
    _startTime = _endTime;

    // if (isMoving) {
    //   wateringCan.tryFire();
    // }

    wateringCan.show(canvas, size, brush);
    wateringCan.update(deltaTime);

    var hitEdge = false;

    final List<Flower> flowersToRemove = [];
    for (final flower in flowers) {
      flower.show(canvas, size, brush);
      flower.update(deltaTime);

      if (flower.hitEdge(size)) hitEdge = true;

      if (flower.passedBottom(size)) {
        print('lost');
      }

      if (flower.hits(wateringCan)) {
        print('lost');
      }

      if (flower.exploded) {
        flowersToRemove.add(flower);
      }
    }

    if (hitEdge) {
      for (final flower in flowers) {
        flower.velocity *= -1.0;
        flower.position = flower.position.translate(0, 40);
      }
    }

    flowers.removeWhere((flower) => flowersToRemove.contains(flower));

    final List<WaterDrop> waterDropsToRemove = [];
    for (final waterDrop in waterDrops) {
      waterDrop.show(canvas, size, brush);
      waterDrop.update(deltaTime);

      if (waterDrop.isOffScreen) {
        waterDropsToRemove.add(waterDrop);
      }

      for (final flower in flowers) {
        if (waterDrop.hits(flower)) {
          flower.grow();
          waterDropsToRemove.add(waterDrop);
        }
      }
    }

    waterDrops.removeWhere((drop) => waterDropsToRemove.contains(drop));
  }

  @override
  bool shouldRepaint(InvadersPainter oldDelegate) => true;
}
