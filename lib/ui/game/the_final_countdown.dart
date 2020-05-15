import 'dart:async';
import 'package:flutter/material.dart';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/utils/game_utils.dart';

enum TheFinalCountdownOrientation { HORIZONTAL, VERTICAL }

class TheFinalCountdownWidget extends StatefulWidget {
  final SizeScreen sizeScreen;

  final GameStatus status;

  final int seconds;

  final int soundVolume;

  final TheFinalCountdownOrientation orientation;

  final Function onCountdownStart;

  final Function onTimeEnd;

  TheFinalCountdownWidget(
      {Key key,
      @required this.sizeScreen,
      @required this.status,
      @required this.seconds,
      @required this.soundVolume,
      @required this.orientation,
      @required this.onCountdownStart,
      @required this.onTimeEnd})
      : super(key: key);

  _TheFinalCountdownWidgetState createState() =>
      _TheFinalCountdownWidgetState();
}

enum TheFinalCountdownStatus { IDLE, COUNTDOWN, CLOCK }

class _TheFinalCountdownWidgetState extends State<TheFinalCountdownWidget>
    with TickerProviderStateMixin {
  Timer _timer;

  TheFinalCountdownStatus _status;

  int _countdown;

  AnimationController _controller;
  Animation<double> _animation;

  AnimationController _scaleController;
  Animation<double> _scaleAnimation;

  bool _fadeCompleted = false;

  @override
  void initState() {
    _timer = null;
    _status = TheFinalCountdownStatus.IDLE;
    _countdown = 3;
    _fadeCompleted = false;

    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = CurveTween(curve: Curves.easeIn).animate(_controller);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _fadeCompleted = true;
        });
      }
    });

    _scaleController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation =
        CurveTween(curve: Curves.easeOut).animate(_scaleController);

    super.initState();
  }

  void onCountDown() {
    widget.onCountdownStart();
    setState(() {
      SoundController.instance.play(SoundEffect.BIP, widget.soundVolume, 1.0);
      _status = TheFinalCountdownStatus.COUNTDOWN;
      _countdown = 3;
      _scaleController.reset();
      _scaleController.forward();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _countdown = _countdown - 1;
          _scaleController.reset();
          _scaleController.forward();
          if (_countdown < 0) {
            _controller.reset();
            _controller.forward();
            _timer.cancel();
            _status = TheFinalCountdownStatus.CLOCK;
            widget.onTimeEnd();
          } else {
            SoundController.instance
                .play(SoundEffect.BIP, widget.soundVolume, 1.0);
          }
        });
      });
    });
  }

  @override
  void didUpdateWidget(TheFinalCountdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == GameStatus.WAITING) {
      setState(() {
        _fadeCompleted = false;
        _status = TheFinalCountdownStatus.IDLE;
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _controller.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  BoxDecoration _boxDecoration(Color color) {
    return BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.roundedLayout));
  }

  @override
  Widget build(BuildContext context) {
    double startButtonHeight = Dimensions.startButtonHeight(widget.sizeScreen);
    double minWidth = Dimensions.getWidthStartButton(widget.sizeScreen, 200);
    double maxWidth = Dimensions.getWidthStartButton(widget.sizeScreen, 300);
    double size = _fadeCompleted
        ? startButtonHeight +
            (widget.seconds * (maxWidth - startButtonHeight)) / GameUtils.maxTime
        : startButtonHeight;
    return GestureDetector(
      onTap: () {
        if (_status == TheFinalCountdownStatus.IDLE) onCountDown();
      },
      child: AnimatedContainer(
        constraints: BoxConstraints.expand(
            height: widget.orientation ==
                    TheFinalCountdownOrientation.HORIZONTAL
                ? startButtonHeight
                : _status == TheFinalCountdownStatus.IDLE ? minWidth : maxWidth,
            width: widget.orientation == TheFinalCountdownOrientation.HORIZONTAL
                ? _status == TheFinalCountdownStatus.IDLE ? minWidth : maxWidth
                : startButtonHeight),
        curve: Curves.easeInOut,
        decoration: _boxDecoration(_status == TheFinalCountdownStatus.IDLE
            ? ResColors.primaryColorDark
            : ResColors.boardBackground),
        duration: Duration(milliseconds: 500),
        child: _status == TheFinalCountdownStatus.IDLE
            ? Center(
                child: RotatedBox(
                  quarterTurns: widget.orientation ==
                          TheFinalCountdownOrientation.HORIZONTAL
                      ? 0
                      : 1,
                  child: Text(
                      ImpossiblocksLocalizations.of(context).text("start"),
                      maxLines: 1,
                      style: ResStyles.startText(widget.sizeScreen)),
                ),
              )
            : _status == TheFinalCountdownStatus.COUNTDOWN
                ? Center(
                    child: ScaleTransition(
                      alignment: Alignment.center,
                      scale: _scaleAnimation,
                      child: RotatedBox(
                        quarterTurns: widget.orientation ==
                                TheFinalCountdownOrientation.HORIZONTAL
                            ? 0
                            : 1,
                        child: Text(
                          _countdown == 0 ? "GO!" : _countdown.toString(),
                          style: ResStyles.countDownText(widget.sizeScreen),
                        ),
                      ),
                    ),
                  )
                : FadeTransition(
                    opacity: _animation,
                    child: Stack(children: <Widget>[
                      AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 200),
                          constraints: BoxConstraints.expand(
                              height: widget.orientation ==
                                      TheFinalCountdownOrientation.HORIZONTAL
                                  ? startButtonHeight
                                  : size,
                              width: widget.orientation ==
                                      TheFinalCountdownOrientation.HORIZONTAL
                                  ? size
                                  : startButtonHeight),
                          decoration: _boxDecoration(Colors.green)),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints.expand(
                              height: startButtonHeight,
                              width: startButtonHeight),
                          decoration: _boxDecoration(ResColors.colorTile1),
                          child: RotatedBox(
                            quarterTurns: widget.orientation ==
                                    TheFinalCountdownOrientation.HORIZONTAL
                                ? 0
                                : 1,
                            child: Text(
                                GameUtils.getTimeFormatted(widget.seconds),
                                style: ResStyles.clock),
                          ))
                    ])),
      ),
    );
  }
}
