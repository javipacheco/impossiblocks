import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:collection/collection.dart';

class CubesBackground extends StatefulWidget {

  final double height;

  CubesBackground({Key key, this.height = 200}) : super(key: key);

  _CubesBackgroundState createState() => _CubesBackgroundState();
}

class _CubesBackgroundState extends State<CubesBackground>
    with SingleTickerProviderStateMixin {
  static double _cubeSize = 25;
  static double _padding = 3;
  static double _cubeAndPaddingSize = _cubeSize + (_padding * 2);

  double _fraction = 0.0;
  Cube changedCube;

  Animation<double> animation;

  var _rng = new Random();

  int cubesWidth;
  int cubesHeight;

  List<int> cubes;

  Timer _timer;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    cubesHeight = widget.height ~/ _cubeAndPaddingSize;

    _controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = animation.value;
        });
      });

    cubes = List.generate(cubesHeight, (i) => 0);

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        if (cubesWidth != null) {
          int row = _rng.nextInt(cubes.length);
          bool positive = _rng.nextBool();

          int ratio = cubesWidth ~/ cubesHeight;
          int columns = cubesWidth - (row * ratio) + cubes[row];

          if (positive && columns >= cubesWidth - 1) {
            positive = false;
          } else if (!positive && columns <= 0) {
            positive = true;
          }

          var newCubes = List.generate(
              cubes.length,
              (i) =>
                  i == row ? positive ? cubes[i] + 1 : cubes[i] - 1 : cubes[i]);
          cubes = newCubes;

          changedCube = Cube(row: row, column: cubes[row], added: positive);

          _controller.reset();
          _controller.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cubesWidth = MediaQuery.of(context).size.width ~/ _cubeAndPaddingSize;
    return SizedBox(
        width: double.infinity,
        height: widget.height,
        child: CustomPaint(
            painter: CubesPainter(cubes, _fraction, changedCube,
                cubesHeight: cubesHeight,
                cubesWidth: cubesWidth,
                cubeSize: _cubeSize,
                padding: _padding)));
  }
}

class Cube {
  final int row;

  final int column;

  final bool added;

  Cube({@required this.row, @required this.column, @required this.added});

  @override
  String toString() {
    return 'Cube{row: $row, column: $column, added: $added}';
  }
}

class CubesPainter extends CustomPainter {
  static Color _color = Colors.grey[200];

  int cubesHeight;
  int cubesWidth;
  double cubeSize;
  double padding;

  double fraction;

  List<int> cubes;

  Cube changedCube;

  CubesPainter(
    this.cubes,
    this.fraction,
    this.changedCube, {
    this.cubesHeight,
    this.cubesWidth,
    this.cubeSize,
    this.padding,
  });

  Paint _paintCube = new Paint()
    ..color = _color
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    int ratio = cubesWidth ~/ cubesHeight;

    List.generate(cubesHeight, (i) => i).forEach((row) {
      int columns = cubesWidth - (row * ratio) + cubes[row];

      var columnsList = List.generate(columns, (i) => i);

      columnsList.forEach((column) {
        RRect rect = RRect.fromLTRBR(
            (column * cubeSize) + padding, // left
            size.height - ((row * cubeSize) + padding), // top
            (column + 1) * cubeSize, // right
            size.height - ((row + 1) * cubeSize), // bottom
            Radius.circular(4));

        if (changedCube != null &&
            row == changedCube.row &&
            columnsList.last == column &&
            changedCube.added) {
          _paintCube.color = _color.withAlpha((fraction * 255).toInt());
        } else {
          _paintCube.color = _color;
        }

        canvas.drawRRect(rect, _paintCube);
      });

      if (changedCube != null && row == changedCube.row && !changedCube.added) {
        int column = columnsList.length;
        RRect rect = RRect.fromLTRBR(
            (column * cubeSize) + padding, // left
            size.height - ((row * cubeSize) + padding), // top
            (column + 1) * cubeSize, // right
            size.height - ((row + 1) * cubeSize), // bottom
            Radius.circular(4));
        _paintCube.color = _color.withAlpha(255 - (fraction * 255).toInt());
        canvas.drawRRect(rect, _paintCube);
      }
    });
  }

  @override
  bool shouldRepaint(CubesPainter oldDelegate) {
    Function eq = const ListEquality().equals;
    return fraction != oldDelegate.fraction ||
        !eq(this.cubes, oldDelegate.cubes);
  }
}
