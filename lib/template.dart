import 'package:flutter/material.dart';

class Template extends StatefulWidget {
  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // _animationController
    //   ..addListener(() {
    //     // debugPrint('${_animationController.value}');
    //     print(_animationController.value);
    //   })
    //   ..forward();

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
    return Scaffold(
      appBar: AppBar(title: Text('Template')),
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, __) {
            return CustomPaint(
              painter: TemplatePainter(),
              willChange: true,
            );
          },
        ),
      ),
    );
  }
}

class TemplatePainter extends CustomPainter {
  const TemplatePainter();

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
