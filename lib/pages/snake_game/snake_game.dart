import 'dart:math';
import 'dart:ui';

import 'package:challenges/mixins/setup_mixin.dart';
import 'package:challenges/pages/snake_game/models/snake.dart';
import 'package:challenges/utils/map_range.dart';
import 'package:flutter/material.dart';

enum GameState { menu, playing, lost }

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;
  Snake snake;
  var snakeGameState = SnakeGameState(GameState.playing);

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
      appBar: AppBar(title: Text('SnakeGame')),
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, __) {
            return CustomPaint(
              key: customPaintKey,
              willChange: true,
              painter: SnakeGamePainter(
                _animationController,
                snake,
                snakeGameState,
              ),
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
    final random = Random();
    // FIXME: This sucks. Just spawn the snake in the middle
    final position = Offset(
      mapRange(random.nextDouble(), 0, 1, 0, size.width),
      mapRange(random.nextDouble(), 0, 1, 0, size.height),
    );
    final speed = Offset(-1, 0);

    final unitHeight = size.height / snakeGameState.rows;
    final unitWidth = size.width / snakeGameState.columns;

    snake = Snake(
      position,
      speed,
      width: unitWidth,
      height: unitHeight,
    );

    snakeGameState.foods.add(
      Food(
        Offset(
          mapRange(random.nextDouble(), 0, 1, 0, size.width),
          mapRange(random.nextDouble(), 0, 1, 0, size.height),
        ),
        width: unitWidth,
        height: unitHeight,
      ),
    );
  }
}

class Food {
  Food(this.position, {@required this.width, @required this.height});

  final Offset position;
  final double width;
  final double height;

  void show(Canvas canvas, Size size, Paint paint) {
    canvas.drawRect(
      Rect.fromLTWH(position.dx, position.dy, width, height),
      paint,
    );
  }
}

/// The snake by of size 1x1 when the game begins.
/// The actual dimensions will be determined by the screen size.
/// e.g., the width will be (1 / 50) * size.width
class SnakeGameState {
  SnakeGameState(
    this.gameState, {
    this.columns = 50,
    this.rows = 50,
  });

  final int columns;
  final int rows;
  final List<Food> foods = [];

  GameState gameState;
}

class SnakeGamePainter extends CustomPainter {
  SnakeGamePainter(this.animation, this.snake, this.snakeGameState)
      : brush = Paint()..color = Colors.white,
        textStyle = TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        checkBounds = false,
        super(repaint: animation);

  static final dPadBottomPadding = 56.0;
  static final buttonLength = 32.0;

  final Animation<double> animation;
  final Snake snake;
  final SnakeGameState snakeGameState;
  final Paint brush;
  final bool checkBounds;

  int score = 0;
  TextStyle textStyle;
  Size _size;

  @override
  void paint(Canvas canvas, Size size) {
    _size = size; // Not ideal

    switch (snakeGameState.gameState) {
      case GameState.menu:
        _showStartScreen(canvas, size);
        break;
      case GameState.playing:
        if (checkBounds) {
          if (_lost(size)) snakeGameState.gameState = GameState.lost;
        } else {
          _drawGrid(canvas, size);
          _clamp(size);
        }
        snake.show(canvas, brush, size);
        snake.update();
        _drawFood(canvas, size);
        _paintScore(canvas, size);
        _drawGamePad(canvas, size);
        break;
      case GameState.lost:
        _paintLostScreen(canvas, size);
        _paintScore(canvas, size);
        break;
    }
  }

  @override
  bool shouldRepaint(SnakeGamePainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    switch (snakeGameState.gameState) {
      case GameState.menu:
        snakeGameState.gameState = GameState.playing;
        break;
      case GameState.lost:
        snakeGameState.gameState = GameState.menu;
        break;
      case GameState.playing:
        _handleDPadInput(position);
        break;
    }

    return true;
  }

  void _drawFood(Canvas canvas, Size size) {
    for (final food in snakeGameState.foods) {
      food.show(canvas, size, brush);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    for (int i = 1; i <= snakeGameState.rows - 1; i++) {
      final height = size.height * (i / snakeGameState.rows);
      canvas.drawLine(Offset(0, height), Offset(size.width, height), brush);
    }
    for (int j = 1; j <= snakeGameState.columns - 1; j++) {
      final width = size.width * (j / snakeGameState.columns);
      canvas.drawLine(Offset(width, 0), Offset(width, size.height), brush);
    }
  }

  /// Checks the bound to see if the snake has gone off the screen
  bool _lost(Size size) {
    if (snake.position.dx - (snake.width / 2) <= 0 ||
        snake.position.dx + (snake.width / 2) >= size.width) {
      return true;
    }

    if (snake.position.dy - (snake.width / 2) <= 0 ||
        snake.position.dy + (snake.height / 2) >= size.height) {
      return true;
    }

    return false;
  }

  void _clamp(Size size) {
    snake.position = Offset(
      snake.position.dx.clamp(0.0, size.width - snake.width),
      snake.position.dy.clamp(0.0, size.height - snake.height),
    );
  }

  void _paintLostScreen(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: 'You lost!\nTap to play again.',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(
      (size.width / 2) - (textPainter.size.width / 2),
      (size.height / 2) - (textPainter.size.height / 2),
    );
    textPainter.paint(canvas, offset);
  }

  void _handleDPadInput(Offset position) {
    final bottomCenter = Offset(
      _size.width / 2,
      _size.height - dPadBottomPadding,
    );
    final rightCenter = Offset(
      _size.width / 2 + (buttonLength * 1.5),
      _size.height - dPadBottomPadding - (buttonLength * 1.5),
    );
    final topCenter = Offset(
      _size.width / 2,
      _size.height - dPadBottomPadding - (buttonLength * 3),
    );
    final leftCenter = Offset(
      _size.width / 2 - (buttonLength * 1.5),
      _size.height - dPadBottomPadding - (buttonLength * 1.5),
    );

    if ((bottomCenter - position).distance <= buttonLength) {
      // Down
      snake.direction = Offset(0, 1);
    }
    if ((rightCenter - position).distance <= buttonLength) {
      // Right
      snake.direction = Offset(1, 0);
    }
    if ((topCenter - position).distance <= buttonLength) {
      // Up
      snake.direction = Offset(0, -1);
    }
    if ((leftCenter - position).distance <= buttonLength) {
      // Left
      snake.direction = Offset(-1, 0);
    }
  }

  void _showStartScreen(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: 'Press the screen to start',
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
    final offset = Offset(
      (size.width / 2) - (textPainter.size.width / 2),
      (size.height / 2) - (textPainter.size.height / 2),
    );
    textPainter.paint(canvas, offset);
  }

  void _drawGamePad(Canvas canvas, Size size) {
    final bottom = size.height - dPadBottomPadding;

    final path = Path()
      ..moveTo((size.width / 2) - (buttonLength / 2), bottom)
      ..relativeLineTo(buttonLength, 0) // right
      ..relativeLineTo(0, -buttonLength) // up
      ..relativeLineTo(buttonLength, 0) // right
      ..relativeLineTo(0, -buttonLength) // up
      ..relativeLineTo(-buttonLength, 0) // left
      ..relativeLineTo(0, -buttonLength) // up
      ..relativeLineTo(-buttonLength, 0) // left
      ..relativeLineTo(0, buttonLength) // down
      ..relativeLineTo(-buttonLength, 0) // left
      ..relativeLineTo(0, buttonLength) // down
      ..relativeLineTo(buttonLength, 0) // right
      ..close();

    canvas.drawPath(path, brush);
  }

  void _paintScore(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: 'Score: $score',
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
}
