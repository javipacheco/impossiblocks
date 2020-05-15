import 'dart:async';
import 'package:flutter/material.dart';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/widgets/circle_progress_background.dart';
import 'package:impossiblocks/utils/game_utils.dart';

class TimerTwoPlayersWidget extends StatefulWidget {
  final SizeScreen sizeScreen;

  final GameStatus status;

  final int seconds;

  final int soundVolume;

  final Function onCountdownStart;

  final Function onTimeEnd;

  TimerTwoPlayersWidget(
      {Key key,
      @required this.sizeScreen,
      @required this.status,
      @required this.seconds,
      @required this.soundVolume,
      @required this.onCountdownStart,
      @required this.onTimeEnd})
      : super(key: key);

  _TimerTwoPlayersWidgetState createState() => _TimerTwoPlayersWidgetState();
}

enum TheFinalCountdownStatus { IDLE, COUNTDOWN, CLOCK }

class _TimerTwoPlayersWidgetState extends State<TimerTwoPlayersWidget>
    with TickerProviderStateMixin {
  Timer _timer;

  TheFinalCountdownStatus _status;

  int _countdown;

  AnimationController _scaleController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    _timer = null;
    _status = TheFinalCountdownStatus.IDLE;
    _countdown = 3;

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
  void didUpdateWidget(TimerTwoPlayersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == GameStatus.WAITING) {
      setState(() {
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
    _scaleController.dispose();
    super.dispose();
  }

  BoxDecoration _boxDecoration(Color color) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    double startButtonSize = Dimensions.startButtonHeight(widget.sizeScreen);
    return GestureDetector(
      onTap: () {
        if (_status == TheFinalCountdownStatus.IDLE) onCountDown();
      },
      child: AnimatedContainer(
        constraints: BoxConstraints.expand(
          width: startButtonSize,
          height: startButtonSize,
        ),
        curve: Curves.easeInOut,
        decoration: _boxDecoration(_status == TheFinalCountdownStatus.IDLE
            ? ResColors.primaryColorDark
            : ResColors.boardBackground),
        duration: Duration(milliseconds: 500),
        child: _status == TheFinalCountdownStatus.IDLE
            ? Center(
                child: Text(
                    ImpossiblocksLocalizations.of(context).text("start"),
                    style: ResStyles.startText2Players(widget.sizeScreen)),
              )
            : _status == TheFinalCountdownStatus.COUNTDOWN
                ? Center(
                    child: ScaleTransition(
                      alignment: Alignment.center,
                      scale: _scaleAnimation,
                      child: Text(
                        _countdown == 0 ? "GO!" : _countdown.toString(),
                        style:
                            ResStyles.countDownText2Players(widget.sizeScreen),
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints.expand(
                        height: startButtonSize, width: startButtonSize),
                    child: CircleProgressBackground(
                      colorBack: Colors.green,
                      colorFront: ResColors.boardBackground,
                      percentage: 100 - (widget.seconds * 100 ~/ GameUtils.maxTime),
                      size: 48,
                      child: Center(
                          child: Text(
                              GameUtils.getTimeFormatted(widget.seconds),
                              style: ResStyles.clock)),
                    )),
      ),
    );
  }
}
