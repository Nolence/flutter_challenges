import 'package:flutter/material.dart';

class Standard extends StatefulWidget {
  @override
  StandardState createState() => StandardState();
}

class StandardState extends State<Standard>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  StandardPainter painter;
  final customPaintKey = GlobalKey();

  var _isInitialized = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        days: 365, // Large durations sometimes breaks android.
      ),
    );

    Future.delayed(Duration.zero, () {
      final context = customPaintKey.currentContext;
      if (context == null)
        throw 'Make sure to add the key \`customPaintKey\` to your `CustomPainter`.';

      final RenderBox box = context.findRenderObject();

      setup(box.size);
      _animationController.forward();
    });

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
      appBar: AppBar(title: Text('Standard')),
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, __) {
            return CustomPaint(
              key: customPaintKey,
              willChange: true,
              painter: _isInitialized ? painter : null,
            );
          },
        ),
      ),
    );
  }

  void setup(Size size) {
    painter = StandardPainter(_animationController);

    setState(() => _isInitialized = true);
  }
}

class StandardPainter extends CustomPainter {
  const StandardPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
