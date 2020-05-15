import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BarProgressBackground extends StatefulWidget {
  final Color colorBack;

  final Color colorFront;

  final double height;

  final int percentage;

  BarProgressBackground(
      {Key key,
      @required this.colorBack,
      @required this.colorFront,
      @required this.height,
      @required this.percentage,})
      : super(key: key);

  _BarProgressBackgroundState createState() => _BarProgressBackgroundState();
}

class _BarProgressBackgroundState extends State<BarProgressBackground>
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
  void didUpdateWidget(BarProgressBackground oldWidget) {
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
           BoxConstraints.expand(height: widget.height, ),
      child: CustomPaint(
        painter: _BarPainter(
            colorFront: widget.colorFront,
            colorBack: widget.colorBack,
            percentage: _getPercentage()),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final Color colorBack;

  final Color colorFront;

  final int percentage;

  _BarPainter({
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

    canvas.drawRRect(
        RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(8.0)),
        _paintBackCircle);

    canvas.drawRRect(
        RRect.fromLTRBR(0, 0, (percentage * size.width) / 100, size.height,
            Radius.circular(8.0)),
        _paintFrontCircle);
  }

  @override
  bool shouldRepaint(_BarPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
