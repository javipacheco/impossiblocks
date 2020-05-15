import 'package:flutter/material.dart';

class TextFade extends StatefulWidget {
  final String message;

  final TextStyle style;

  const TextFade({Key key, @required this.message, @required this.style})
      : super(key: key);

  _TextFadeState createState() => _TextFadeState();
}

class _TextFadeState extends State<TextFade> with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _animation;

  String prevMessage;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = CurveTween(curve: Curves.easeIn).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          prevMessage = null;
          _controller.reset();
          _controller.forward();
        });
      }
    });

    _controller.forward();

    super.initState();
  }

  @override
  void didUpdateWidget(TextFade oldWidget) {
    if (oldWidget.message != widget.message) {
      setState(() {
        prevMessage = oldWidget.message;
        _controller.reverse();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(prevMessage != null ? prevMessage : widget.message,
          style: widget.style),
    );
  }
}
