import 'dart:math';

import 'package:challenges/utils/string_utils.dart';
import 'package:flutter/material.dart';

// Add L System fractals
// https://www.youtube.com/watch?v=E1B4UoSQMFw

enum FractalType { simple, lSystem }

class Fractals extends StatefulWidget {
  @override
  _FractalsState createState() => _FractalsState();
}

class _FractalsState extends State<Fractals>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  var _length = 100.0;
  Animation<double> _simpleAngle;
  Animation<double> _lAngle;
  var _fractalType = FractalType.lSystem;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });

    final Animation curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _simpleAngle = Tween(begin: pi / 4, end: pi / 3).animate(curve);
    _lAngle = Tween(begin: 25.43, end: 25.57).animate(curve);

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
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fractal Trees'),
          elevation: 0,
          actions: <Widget>[
            DropdownButton<FractalType>(
              value: _fractalType,
              onChanged: (value) => setState(() => _fractalType = value),
              items: FractalType.values.map(
                (value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(capitalize(value.toString().split('.')[1])),
                  );
                },
              ).toList(),
            )
          ],
        ),
        body: SizedBox.expand(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: FractalPainter(
                  length: _length,
                  simpleAngle: _simpleAngle.value,
                  lAngle: _lAngle.value,
                  fractalType: _fractalType,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Given a, a will map to b
/// e.g. (A -> AB)
/// e.g. (B -> A)
class Rule {
  const Rule(this.a, this.b);

  final String a;
  final String b;
}

class FractalPainter extends CustomPainter {
  FractalPainter({
    @required this.simpleAngle,
    @required this.lAngle,
    @required this.length,
    @required this.fractalType,
  }) : brush = Paint()
          ..color = Colors.indigo[100]
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.butt;

  final double simpleAngle;
  final double lAngle;
  final double length;
  final Paint brush;
  final FractalType fractalType;

  final List<Rule> rules = [
    Rule('F', 'FF+[+F-F-F]-[-F+F+F]'),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    switch (fractalType) {
      case FractalType.simple:
        canvas.translate(size.width / 2, size.height * .64);
        _branch(canvas, size, length);
        break;
      case FractalType.lSystem:
        {
          var newLength = length * 0.7;
          brush..color = Colors.indigo[100].withOpacity(.5);
          canvas.translate(size.width / 2, size.height);
          final axiom = 'F';
          _turtle(canvas, size, newLength, axiom);
          var nextAxiom = _generate(axiom);
          newLength = length * 0.5;
          _turtle(canvas, size, newLength, nextAxiom);
          nextAxiom = _generate(nextAxiom);
          newLength *= 0.5;
          _turtle(canvas, size, newLength, nextAxiom);
          nextAxiom = _generate(nextAxiom);
          newLength *= 0.5;
          _turtle(canvas, size, newLength, nextAxiom);
          nextAxiom = _generate(nextAxiom);
          newLength *= 0.5;
          _turtle(canvas, size, newLength, nextAxiom);
        }
        break;
      default:
        throw 'Not implemented';
    }
  }

  @override
  bool shouldRepaint(FractalPainter oldDelegate) {
    return lAngle != oldDelegate.lAngle ||
        simpleAngle != oldDelegate.simpleAngle;
  }

  String _generate(String axiom) {
    var nextSentence = '';

    for (int i = 0; i < axiom.length; i++) {
      final current = axiom[i];
      var found = false;

      for (final rule in rules) {
        if (current == rule.a) {
          found = true;
          nextSentence += rule.b;
          break;
        }
      }

      if (!found) {
        nextSentence += current;
      }
    }

    return nextSentence;
  }

  void _turtle(Canvas canvas, Size size, double length, String axiom) {
    for (var i = 0; i < axiom.length; i++) {
      final current = axiom[i];

      if (current == 'F') {
        canvas.drawLine(Offset(0, 0), Offset(0, -length), brush);
        canvas.translate(0, -length);
      } else if (current == '+') {
        canvas.rotate(lAngle);
      } else if (current == '-') {
        canvas.rotate(-lAngle);
      } else if (current == '[') {
        canvas.save();
      } else if (current == ']') {
        canvas.restore();
      }
    }
  }

  void _branch(Canvas canvas, Size size, double length) {
    canvas.drawLine(
      Offset(0, 0),
      Offset(0, -length),
      brush,
    );
    canvas.translate(0, -length);
    if (length > 2) {
      canvas.save();
      canvas.rotate(simpleAngle);
      _branch(canvas, size, length * 0.67);
      canvas.restore();
      canvas.save();
      canvas.rotate(-simpleAngle);
      _branch(canvas, size, length * 0.67);
      canvas.restore();
    }
  }
}
