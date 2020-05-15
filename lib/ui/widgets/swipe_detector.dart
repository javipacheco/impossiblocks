import 'package:flutter/material.dart';
import 'package:impossiblocks/models/app_state.dart';

class SwipeDetector extends StatefulWidget {
  final Widget child;

  final double tileSize;

  final Function(SwipeMove) onSwipe;

  SwipeDetector(
      {Key key,
      @required this.child,
      @required this.tileSize,
      @required this.onSwipe})
      : super(key: key);

  _SwipeDetectorState createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  Offset _swipe;

  int _row;

  int _column;

  @override
  void initState() {
    _swipe = Offset.zero;
    _row = 0;
    _column = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (gesture) {
        RenderBox object = context.findRenderObject();
        Offset _localPosition = object.globalToLocal(gesture.globalPosition);
        _column = _localPosition.dx ~/ widget.tileSize;
        _row = _localPosition.dy ~/ widget.tileSize;
        setState(() {
          _swipe = Offset.zero;
        });
      },
      onPanUpdate: (gesture) {
        setState(() {
          _swipe = _swipe + gesture.delta;
        });
      },
      onPanEnd: (gesture) {
        setState(() {
          if ((_swipe.dx.abs() > _swipe.dy.abs() ? _swipe.dx.abs() : _swipe.dy.abs()) > 30) {
            Move horizontal = _swipe.dx > 0 ? Move.RIGHT : Move.LEFT;
            Move vertical = _swipe.dy > 0 ? Move.DOWN : Move.UP;
            Move move = _swipe.dx.abs() > _swipe.dy.abs() ? horizontal : vertical;
            widget.onSwipe(SwipeMove(move: move, row: _row, column: _column));
          }
          _swipe = Offset.zero;
        });
      },
      child: widget.child,
    );
  }
}

enum Move { UP, DOWN, LEFT, RIGHT, IDLE }

class SwipeMove {
  final Move move;

  final int row;

  final int column;

  SwipeMove({@required this.move, @required this.row, @required this.column});

  factory SwipeMove.empty() {
    return SwipeMove(move: Move.IDLE, row: 0, column: 0);
  }

  bool shouldMove(Movement movement) {
    if (move == Move.UP || move == Move.DOWN) {
      return movement.column == column;
    } else {
      return movement.row == row;
    }
  }

  @override
  String toString() {
    return "SwipeMove{move: $move, row: $row, column: $column}";
  }
}
