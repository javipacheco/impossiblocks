import 'package:flutter/material.dart';

class BoardTranslate extends StatefulWidget {

  final Widget child;

  BoardTranslate({Key key, @required this.child}) : super(key: key);

  _BoardTranslateState createState() => _BoardTranslateState();
}

class _BoardTranslateState extends State<BoardTranslate> with SingleTickerProviderStateMixin {

  Animation<double> _animation;

  AnimationController _controller;

  double _fraction = 0.0;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final curvedValue = Curves.easeInOutBack.transform(_fraction) - 1.0;
    return Transform(
            transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0.0),
            child: Opacity(
              opacity: _fraction,
       child: widget.child,
            )
    );
  }
}