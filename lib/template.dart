import 'package:challenges/mixins/setup_mixin.dart';
import 'package:flutter/material.dart';

class Template extends StatefulWidget {
  @override
  _TemplateState createState() => _TemplateState();
}

class _TemplateState extends State<Template>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
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
              key: customPaintKey,
              painter: TemplatePainter(_animationController),
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

class TemplatePainter extends CustomPainter {
  const TemplatePainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
