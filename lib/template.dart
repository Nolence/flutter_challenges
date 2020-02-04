import 'package:challenges/mixins/setup_mixin.dart';
import 'package:flutter/material.dart';

class Template extends StatefulWidget {
  @override
  TemplateState createState() => TemplateState();
}

class TemplateState extends State<Template>
    with SingleTickerProviderStateMixin, SetupMixin {
  AnimationController _animationController;
  bool _isInitialized = false;

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
      appBar: AppBar(title: Text('Template')),
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, __) {
            return CustomPaint(
              key: customPaintKey,
              willChange: true,
              painter: _isInitialized
                  ? TemplatePainter(_animationController, this)
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

class TemplatePainter extends CustomPainter {
  const TemplatePainter(this.animation, this.state) : super(repaint: animation);

  final Animation<double> animation;
  final TemplateState state;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
