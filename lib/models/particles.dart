import 'dart:math';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:flutter/material.dart';

class ParticleModel {
  Animatable tween;
  Color color;
  double size;
  AnimationProgress animationProgress;
  Random random;
  int count = 0;
  int max;

  ParticleModel(this.random, this.max) {
    restart();
  }

  restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final duration = Duration(milliseconds: 1000 + random.nextInt(2000));

    tween = MultiTrackTween([
      Track("x").add(
          duration, Tween(begin: startPosition.dx, end: endPosition.dx),
          curve: Curves.easeInOutSine),
      Track("y").add(
          duration, Tween(begin: startPosition.dy, end: endPosition.dy),
          curve: Curves.easeIn),
      Track("rotate").add(
          duration, Tween(begin: 0, end: 360),
          curve: Curves.easeIn),
    ]);
    animationProgress = AnimationProgress(duration: duration, startTime: time);
    size = 0.6 + random.nextDouble() * 20;
    color = random.nextBool() ? ResColors.colorTile1 : ResColors.colorTile2;
  }

  maintainRestart(Duration time) {
    if (animationProgress.progress(time) == 1.0 && count < max) {
      count = count + 1;
      restart(time: time);
    }
  }
}