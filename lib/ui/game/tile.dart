import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/ui/widgets/swipe_detector.dart';
import 'package:impossiblocks/ui/widgets/tile_transation.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:impossiblocks/res/res_colors.dart';

class Tile extends StatefulWidget {
  final SizeScreen sizeScreen;

  final int position;

  final double tileSize;

  final GameStatus status;

  final bool noAnimation;

  final TileStatus tileStatus;

  final int columns;

  final Move move;

  final bool userRemovedAnimations;

  final GestureTapCallback onTap;

  final GestureLongPressCallback onLongTap;

  final Function onEndFlicker;

  Tile({
    Key key,
    @required this.sizeScreen,
    @required this.position,
    @required this.tileSize,
    @required this.status,
    @required this.noAnimation,
    @required this.columns,
    @required this.tileStatus,
    @required this.move,
    @required this.userRemovedAnimations,
    @required this.onTap,
    @required this.onLongTap,
    @required this.onEndFlicker,
  }) : super(key: key);

  @override
  TileState createState() => TileState();
}

class TileState extends State<Tile> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _tileTween;
  AnimationController _flickerController;
  Animation _flickerTween;
  double _flickerValue = 0;
  bool isReversing;
  int prevNumber;
  TypeTile prevIcon;

  @override
  void initState() {
    _flickerController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _flickerTween =
        Tween<double>(begin: 0.0, end: 1).animate(_flickerController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _flickerController.reverse();
            }
            if (status == AnimationStatus.dismissed) {
              widget.onEndFlicker();
            }
          })
          ..addListener(() {
            setState(() {
              _flickerValue = _flickerTween.value;
            });
          });

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _tileTween = Tween(begin: 0.0, end: 0.25).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
          setState(() {
            isReversing = true;
            prevIcon = null;
            prevNumber = null;
          });
        }
        if (status == AnimationStatus.dismissed) {
          setState(() {
            isReversing = false;
          });
        }
      });

    isReversing = false;
    prevIcon = null;

    super.initState();
  }

  @override
  void didUpdateWidget(Tile oldWidget) {
    if (!widget.userRemovedAnimations) {
      // se produce un cambio de color o de tipo de icono hay animacíón
      bool anim = false;
      if (!widget.noAnimation &&
          !_animationController.isAnimating &&
          (oldWidget.tileStatus.color != widget.tileStatus.color ||
              oldWidget.tileStatus.typeTile != widget.tileStatus.typeTile)) {
        setState(() {
          prevNumber = oldWidget.tileStatus.color;
        });
        anim = true;
      }

      // si viene de un icono, se guarda para pintarlo en la primera parte de la animación
      if (!widget.noAnimation &&
          !_animationController.isAnimating &&
          oldWidget.tileStatus.typeTile != null) {
        setState(() {
          prevIcon = oldWidget.tileStatus.typeTile;
        });
      }

      if (anim) _animationController.forward();
    }

    if (widget.tileStatus.flicker) {
      _flickerController.reset();
      _flickerController.forward();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double sizeIcon = Dimensions.getSizeIcon(widget.sizeScreen,
        widget.columns == 3 ? 50 : widget.columns == 4 ? 40 : 32);
    return TileTransition(
      widget.move,
      turns: _tileTween,
      child: Container(
        decoration: buildBoxDecoration(_flickerValue >= 0
            ? Colors.yellow.withAlpha((255 * _flickerValue).toInt())
            : Colors.transparent),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.paddingTile),
          child: GestureDetector(
            onTap: () {
              widget.onTap();
            },
            onLongPress: () {
              widget.onLongTap();
            },
            child: SizedBox(
                width: widget.tileSize,
                height: widget.tileSize +
                    ((widget.columns - 3) *
                        5), // TODO está feo, es para ajustar el alto. Hay que mejorarlo
                child: Container(
                  decoration: buildBoxDecoration(_getColor()),
                  child: Center(
                      child: drawIcon()
                          ? Center(
                              child: SvgPicture.asset(
                                _getIcon(prevIcon != null &&
                                        _isFirstPartOfAnimation()
                                    ? prevIcon
                                    : widget.tileStatus.typeTile),
                                color: Colors.white54,
                                width: sizeIcon,
                                height: sizeIcon,
                              ),
                            )
                          : SizedBox.shrink()),
                )),
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration(Color color) {
    return new BoxDecoration(
        color: color,
        borderRadius: new BorderRadius.all(
            Radius.circular(Dimensions.roundedBoard(widget.columns))));
  }

  bool drawIcon() {
    return widget.status == GameStatus.PLAYING &&
        ((widget.tileStatus.typeTile != TypeTile.NORMAL &&
                !_isFirstPartOfAnimation()) ||
            (prevIcon != null &&
                prevIcon != TypeTile.NORMAL &&
                _isFirstPartOfAnimation()));
  }

  bool _isFirstPartOfAnimation() {
    if (widget.status == GameStatus.PLAYING) {
      if (_animationController.isAnimating) {
        return !isReversing;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  String _getIcon(TypeTile typeTile) {
    return typeTile == TypeTile.FIRE
        ? "assets/images/ic_fire.svg"
        : widget.tileStatus.typeTile == TypeTile.LIGHTNING
            ? "assets/images/ic_ray.svg"
            : "assets/images/ic_lock.svg";
  }

  Color _getColor() {
    if (widget.status == GameStatus.PLAYING) {
      if (prevNumber == null) {
        return _getColorByNumber(widget.tileStatus.color);
      } else {
        if (_animationController.isAnimating) {
          if (isReversing) {
            return _getColorByNumber(widget.tileStatus.color);
          } else {
            return _getColorByNumber(prevNumber);
          }
        } else {
          return _getColorByNumber(widget.tileStatus.color);
        }
      }
    } else {
      return Colors.grey;
    }
  }

  Color _getColorByNumber(int number) {
    return number == 0 ? ResColors.colorTile1 : ResColors.colorTile2;
  }
}
