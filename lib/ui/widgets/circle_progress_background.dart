import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

class CircleProgressBackground extends StatefulWidget {
  final Color colorBack;

  final Color colorFront;

  final double size;

  final int percentage;

  final Widget child;

  CircleProgressBackground(
      {Key key,
      @required this.colorBack,
      @required this.colorFront,
      @required this.size,
      @required this.percentage,
      @required this.child})
      : super(key: key);

  _CircleProgressBackgroundState createState() =>
      _CircleProgressBackgroundState();
}

class _CircleProgressBackgroundState extends State<CircleProgressBackground>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _animation;

  int _oldPercentage;

  double _fraction = 0.0;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      });
    super.initState();
  }

  @override
  void didUpdateWidget(CircleProgressBackground oldWidget) {
    if (oldWidget.percentage != widget.percentage) {
      setState(() {
        _oldPercentage = oldWidget.percentage;
      });
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _getPercentage() {
    if (_controller.isAnimating) {
      return (_oldPercentage +
              ((widget.percentage - _oldPercentage) * _fraction))
          .toInt();
    } else {
      return widget.percentage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints.expand(height: widget.size, width: widget.size),
      child: CustomPaint(
        painter: _CirclePainter(
            colorFront: widget.colorFront,
            colorBack: widget.colorBack,
            percentage: _getPercentage()),
        child: widget.child,
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color colorBack;

  final Color colorFront;

  final int percentage;

  _CirclePainter({
    this.colorBack,
    this.colorFront,
    this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint _paintFrontCircle = new Paint()
      ..color = colorFront
      ..style = PaintingStyle.fill;

    Paint _paintBackCircle = new Paint()
      ..color = colorBack
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        size.center(Offset.zero), size.width / 2, _paintBackCircle);

    canvas.drawArc(new Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        -pi / 2, percentage * pi * 2 / 100, true, _paintFrontCircle);
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
