import 'dart:async';

import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {
  final List<Widget> children;

  const Marquee({Key key, this.children}) : super(key: key);

  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with TickerProviderStateMixin {
  Timer _timer;

  AnimationController _controller;

  Animation<double> _animation;

  int _position = 0;

  @override
  void initState() {
    _position = 0;
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      setState(() {
        _controller.reverse();
      });
    });

    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = CurveTween(curve: Curves.easeIn).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          int nextPos = _position + 1;
          _position = nextPos >= widget.children.length ? 0 : nextPos;
          _controller.reset();
          _controller.forward();
        });
      }
    });

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.children[_position],
    );
  }
}
