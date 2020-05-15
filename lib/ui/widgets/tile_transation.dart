import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:impossiblocks/ui/widgets/swipe_detector.dart';

class TileTransition extends AnimatedWidget {
  const TileTransition(this.move, {
    Key key,
    @required Animation<double> turns,
    this.alignment = Alignment.center,
    this.child,
  })  : assert(turns != null),
        super(key: key, listenable: turns);

  Animation<double> get turns => listenable;

  final Move move;

  final Alignment alignment;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = move == Move.UP ?
      Matrix4.rotationX(turnsValue * math.pi * 2.0) :
      move == Move.DOWN ?
      Matrix4.rotationX(turnsValue * math.pi * 2.0) :
      move == Move.LEFT ?
      Matrix4.rotationY(-turnsValue * math.pi * 2.0) :
      Matrix4.rotationY(turnsValue * math.pi * 2.0);
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}
