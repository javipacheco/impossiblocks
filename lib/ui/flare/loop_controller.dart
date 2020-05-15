import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/src/foundation/change_notifier.dart';

class LoopController implements FlareController {
  final String _animation;
  final int _timeAnimation;
  final double _mix;

  double _duration = 0.0;
  ActorAnimation _actor;

  LoopController(this._animation, this._timeAnimation, [this._mix = 0.5]);

  @override
  void initialize(FlutterActorArtboard artboard) {
    _actor = artboard.getAnimation(_animation);
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _duration += elapsed;

    if (_duration > _timeAnimation) _duration = 0;
    _actor.apply(_duration, artboard, _mix);
    
    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  ValueNotifier<bool> isActive = ValueNotifier<bool>(true);

}
