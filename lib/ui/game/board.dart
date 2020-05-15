import 'package:flutter/material.dart';
import 'package:impossiblocks/ui/game/board_translate.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';
import 'dart:math';
import 'package:impossiblocks/ui/widgets/swipe_detector.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/ui/game/viewmodels/board_view_model.dart';
import 'package:impossiblocks/utils/size_utils.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'tile.dart';

class Board extends StatefulWidget {
  final bool twoPlayers;

  final PlayersGame playersGame;

  Board({Key key, @required this.twoPlayers, @required this.playersGame})
      : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> with SingleTickerProviderStateMixin {
  SwipeMove _swipeMove;

  double _fraction = 0.0;

  double _tileSizeForTile = 0.0;

  double _tileSize = 0.0;

  bool _noTileAnimation = false;

  Animation<double> _animation;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _swipeMove = SwipeMove.empty();

    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      });
  }

  List<int> _getRow(BoardStatus board) {
    if (_swipeMove.move == Move.UP) {
      return List.generate(board.columns, (i) => i);
    } else if (_swipeMove.move == Move.DOWN) {
      return List.generate(
          board.columns, (i) => i + (board.columns * (board.rows - 1)));
    } else if (_swipeMove.move == Move.LEFT) {
      return List.generate(board.rows, (i) => board.columns * i);
    } else if (_swipeMove.move == Move.RIGHT) {
      return List.generate(
          board.rows, (i) => (board.columns * i) + (board.columns - 1));
    }
    return List();
  }

  Matrix4 _getMatrix(bool isScaled, Movement movement, int columns) {
    Matrix4 getMatrixRotate() {
      double negativeFraction = 1.0 - (1.0 * _fraction);
      if (_swipeMove.move == Move.UP) {
        if (_fraction > 0.5) {
          return Matrix4.identity()
            ..setEntry(3, 2, 0.005)
            ..translate(0.0, _tileSize * (columns - 1), 0.0)
            ..rotateX((pi / 2) * negativeFraction);
        } else {
          return Matrix4.identity()
            ..setEntry(3, 2, 0.005)
            ..rotateX((pi * negativeFraction) + pi);
        }
      } else if (_swipeMove.move == Move.DOWN) {
        if (_fraction > 0.5) {
          return Matrix4.identity()
            ..setEntry(3, 2, -0.005)
            ..translate(0.0, -_tileSize * (columns - 1), 0.0)
            ..rotateX((pi / 2) * negativeFraction);
        } else {
          return Matrix4.identity()
            ..setEntry(3, 2, 0.005)
            ..rotateX(pi * _fraction);
        }
      } else if (_swipeMove.move == Move.LEFT) {
        double up = 1.0 - (1.0 * _fraction);
        if (_fraction > 0.5) {
          return Matrix4.identity()
            ..setEntry(3, 2, -0.005)
            ..translate(_tileSize * (columns - 1))
            ..rotateY((pi / 2) * up);
        } else {
          return Matrix4.identity()
            ..setEntry(3, 2, 0.005)
            ..rotateY((pi) * _fraction);
        }
      } else if (_swipeMove.move == Move.RIGHT) {
        double up = 1.0 - (1.0 * _fraction);
        if (_fraction > 0.5) {
          return Matrix4.identity()
            ..setEntry(3, 2, 0.005)
            ..translate(-_tileSize * (columns - 1))
            ..rotateY((pi / 2) * up);
        } else {
          return Matrix4.identity()
            ..setEntry(3, 2, 0.005)
            ..rotateY((pi) * up);
        }
      }
      return Matrix4.identity();
    }

    Vector3 getVector3() {
      if (_swipeMove.move == Move.UP) {
        return Vector3(0, -_fraction * _tileSize, 0);
      } else if (_swipeMove.move == Move.DOWN) {
        return Vector3(0, _fraction * _tileSize, 0);
      } else if (_swipeMove.move == Move.LEFT) {
        return Vector3(-_fraction * _tileSize, 0, 0);
      } else if (_swipeMove.move == Move.RIGHT) {
        return Vector3(_fraction * _tileSize, 0, 0);
      }
      return Vector3.zero();
    }

    if (_swipeMove.shouldMove(movement)) {
      if (isScaled) {
        return getMatrixRotate();
      } else {
        return Matrix4.translation(getVector3());
      }
    } else {
      return Matrix4.identity();
    }
  }

  List<int> _positionsToSwipe(BoardStatus board) {
    return List.generate(board.columns * board.rows, (i) => i).where((i) {
      Movement movement = Movement.byPosition(board, i);
      return _swipeMove.shouldMove(movement);
    }).toList();
  }

  bool _shouldBlockSwipeMove(BoardStatus board) {
    bool allIs(List<int> values, int compare) {
      return values.fold(true, (bool acc, int v) => acc && v == compare);
    }

    bool atLeastOneIs(List<int> values, int compare) {
      return values.firstWhere((v) => v == compare, orElse: () => null) != null;
    }

    List<int> colors =
        _positionsToSwipe(board).map((i) => board.tiles[i].color).toList();

    List<int> normalTyles = _positionsToSwipe(board)
        .map((i) => board.tiles[i].typeTile == TypeTile.NORMAL ? 1 : 0)
        .toList();

    return atLeastOneIs(normalTyles, 1) &&
        (allIs(colors, 0) || allIs(colors, 1));
  }

  Widget _tile(BoardViewModel viewModel, int position, bool noAnimation) {
    Movement movement = Movement.byPosition(viewModel.board, position);
    bool isScaled = _getRow(viewModel.board).contains(position);
    return Transform(
      alignment: FractionalOffset.center,
      transform: _getMatrix(isScaled, movement, viewModel.board.columns),
      child: Tile(
        sizeScreen: viewModel.sizeScreen,
        position: position,
        tileSize: _tileSizeForTile,
        noAnimation: noAnimation,
        tileStatus: viewModel.board.getValue(position),
        columns: viewModel.board.columns,
        move: _swipeMove.move,
        userRemovedAnimations: viewModel.userRemoveAnimations,
        status: viewModel.gameViewStatus.status,
        onTap: () {
          if (!_controller.isAnimating) {
            _swipeMove = SwipeMove.empty();
            viewModel.onClickTile(movement);
          }
        },
        onLongTap: () {
          _swipeMove = SwipeMove.empty();
          viewModel.onLongClickTile(movement);
        },
        onEndFlicker: () => viewModel.onDeactivateFlicker(position),
      ),
    );
  }

  List<TableRow> _board(BoardViewModel viewModel) {
    bool noAnimation = _noTileAnimation;
    if (_noTileAnimation) _noTileAnimation = false;
    return List.generate(viewModel.board.rows, (i) => i).map((row) {
      return TableRow(
          children:
              List.generate(viewModel.board.columns, (i) => i).map((column) {
        return TableCell(
          child: _tile(viewModel, (row * viewModel.board.columns) + column,
              noAnimation),
        );
      }).toList());
    }).toList();
  }

  void _resetTileSize(SizeScreen sizeScreen, int columns,
      TypeBoardGame typeBoard, bool hasAssistance) {
    setState(() {
      if (widget.twoPlayers) {
        _tileSizeForTile =
            SizeUtils.getTileSizeForTwoPlayers(context, sizeScreen, columns);
      } else {
        _tileSizeForTile = SizeUtils.getTileSize(
            context,
            sizeScreen,
            columns,
            typeBoard == TypeBoardGame.ARCADE ||
                (typeBoard == TypeBoardGame.LEVEL && hasAssistance),
            typeBoard != TypeBoardGame.LEVEL);
      }
      _tileSize = _tileSizeForTile + (Dimensions.paddingTile * (columns - 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BoardViewModel>(
        distinct: true,
        converter: (store) => BoardViewModel.build(store, widget.playersGame),
        onInitialBuild: (viewModel) {
          _resetTileSize(
              viewModel.sizeScreen,
              viewModel.columns,
              viewModel.board.typeBoard,
              viewModel.board.assistance != null);
          setState(() {
            _animation.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                _noTileAnimation = true;
                setState(() {
                  viewModel.onUpdateTilesAfterSwipe(_swipeMove);
                  _swipeMove = SwipeMove.empty();
                  _fraction = 0;
                });
              }
            });
          });
        },
        onWillChange: (viewModel) {
          _resetTileSize(
              viewModel.sizeScreen,
              viewModel.columns,
              viewModel.board.typeBoard,
              viewModel.board.assistance != null);
        },
        builder: (context, viewModel) {
          return BoardTranslate(
            child: Container(
              decoration: new BoxDecoration(
                  color: ResColors.boardBackground,
                  borderRadius: new BorderRadius.all(Radius.circular(
                      Dimensions.roundedBoard(viewModel.board.columns)))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (viewModel.board.typeBoard == TypeBoardGame.ARCADE ||
                      (viewModel.board.typeBoard == TypeBoardGame.LEVEL &&
                          viewModel.board.assistance != null))
                    Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.paddingTile,
                          left: Dimensions.paddingTile,
                          right: Dimensions.paddingTile),
                      child: AssistanceBar(
                          sizeScreen: viewModel.sizeScreen,
                          playersGame: widget.playersGame),
                    ),
                  SwipeDetector(
                    onSwipe: (swipeMove) {
                      if (viewModel.isGameStatus(GameStatus.PLAYING)) {
                        setState(() {
                          _swipeMove = swipeMove;
                          if (_shouldBlockSwipeMove(viewModel.board)) {
                            viewModel.onBlockTiles(
                                _positionsToSwipe(viewModel.board));
                          } else {
                            viewModel.onSwipeTiles();
                            _controller.reset();
                            _controller.forward();
                          }
                        });
                      }
                    },
                    tileSize: _tileSize,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.paddingTile),
                      child: Table(
                        defaultColumnWidth: FixedColumnWidth(_tileSize),
                        children: viewModel.board != null
                            ? _board(viewModel)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
