import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/app_state.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:impossiblocks/ui/widgets/dialogs/common_dialog_view_model.dart';
import 'package:impossiblocks/ui/widgets/fireworks.dart';
import 'package:impossiblocks/ui/widgets/fortune-wheel.dart';

class FortuneWheelDialog extends StatefulWidget {
  static show(BuildContext context, int soundVolume, Function onLuckPoints) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return;
        },
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: FortuneWheelDialog(
                  onLuckPoints: onLuckPoints, soundVolume: soundVolume),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300));
  }

  final Function onLuckPoints;

  final int soundVolume;

  FortuneWheelDialog(
      {Key key, @required this.onLuckPoints, @required this.soundVolume})
      : super(key: key);

  _FortuneWheelDialogState createState() => _FortuneWheelDialogState();
}

class _FortuneWheelDialogState extends State<FortuneWheelDialog>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  int coins = 0;
  bool finished = false;
  AnimationController _controller;
  Animation _animation;
  List<Luck> _items = [
    Luck(5, Colors.cyan),
    Luck(10, Colors.blue),
    Luck(5, Colors.cyan),
    Luck(10, Colors.blue),
    Luck(5, Colors.cyan),
    Luck(20, Colors.pink),
    Luck(5, Colors.cyan),
    Luck(30, Colors.red),
  ];

  @override
  void initState() {
    super.initState();
    var _duration = Duration(milliseconds: 5000);
    _controller = AnimationController(vsync: this, duration: _duration);
    _animation = CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          finished = true;
          var _index = _calIndex(_animation.value * _angle + _current);
          coins = _items[_index].coins;
          widget.onLuckPoints(coins);
        });
        SoundController.instance.play(
            coins > 25
                ? SoundEffect.LONG_CELEBRATION
                : coins >= 10
                    ? SoundEffect.MIDDLE_CELEBRATION
                    : SoundEffect.SHORT_CELEBRATION,
            widget.soundVolume,
            1.0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.roundedLayout),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context),
        ),
        if (finished)
          Positioned.fill(
              child: IgnorePointer(
                  child: Fireworks(
                      coins * 2, coins > 25 ? 2 : coins >= 10 ? 1 : 0))),
      ],
    );
  }

  dialogContent(BuildContext context) {
    return StoreConnector<AppState, CommonDialogViewModel>(
        distinct: true,
        converter: (store) => CommonDialogViewModel.build(store),
        builder: (context, viewModel) {
          return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final _value = _animation.value;
                final _angle = _value * this._angle;
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    FortuneWheel(
                        sizeScreen: viewModel.sizeScreen,
                        items: _items,
                        current: _current,
                        angle: _angle),
                    _buildGo(viewModel.sizeScreen),
                    _buildResult(viewModel.sizeScreen, _value),
                  ],
                );
              });
        });
  }

  _buildGo(SizeScreen sizeScreen) {
    return Material(
      color: Colors.white,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          width: 72,
          child: Text(
            finished ? coins.toString() : "GO",
            style: ResStyles.big(sizeScreen, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: _startSpinning,
      ),
    );
  }

  _startSpinning() {
    if (!finished && !_controller.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(20) + _random;
      _controller.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _controller.reset();
      });
    }
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    return (((_base + value) % 1) * _items.length).floor();
  }

  _buildResult(SizeScreen sizeScreen, _value) {
    var _index = _calIndex(_value * _angle + _current);
    int coins = _items[_index].coins;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 100,
            height: Dimensions.getHeightContainer(sizeScreen, 60),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Dimensions.paddingDialog),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "$coins",
                style: ResStyles.big(sizeScreen),
              ),
            ),
          ),
          ActionButtonDialog(
              sizeScreen: sizeScreen,
              text: ImpossiblocksLocalizations.of(context).text("cancel"),
              pressed: () {
                Navigator.pop(context, true);
              }),
        ],
      ),
    );
  }
}
