import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/modules/modules.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/ui/game/new_level_panel.dart';
import 'package:impossiblocks/ui/game/the_final_countdown.dart';
import 'package:impossiblocks/ui/widgets/cubes_background.dart';
import 'package:impossiblocks/ui/widgets/dialogs/game_success_dialog.dart';
import 'package:impossiblocks/ui/widgets/dialogs/rating_dialog.dart';
import 'package:impossiblocks/ui/widgets/rounded_container.dart';
import 'package:impossiblocks/ui/widgets/dialogs/level_success_dialog.dart';
import 'package:impossiblocks/ui/widgets/dialogs/tutorial_dialog.dart';
import 'viewmodels/game_container_view_model.dart';
import 'board.dart';
import 'top_info_layout.dart';

class GameContainer extends StatefulWidget {
  GameContainer({Key key}) : super(key: key);

  @override
  _GameContainerState createState() => _GameContainerState();
}

class _GameContainerState extends State<GameContainer> {
  Timer _timerGame;
  @override
  void initState() {
    super.initState();
    _timerGame = null;
  }

  GameContainerPrevViewModel _gameContainerPrevViewModel =
      GameContainerPrevViewModel();

  void _showTutorialIfNeeded(GameContainerViewModel viewModel) {
    if (viewModel.boardStatus.typeBoard == TypeBoardGame.LEVEL) {
      int world = viewModel.levelListState.currentWorld;
      int level = viewModel.levelListState.currentLevel;
      viewModel.levelCompleted().then((completed) {
        if (!completed) {
          if (!viewModel.userVisitedStore && world == 1 && level == 7) {
            Timer(Duration(milliseconds: 400), () {
              RatingDialog.show(context);
            });
          } else if (ImpossiblocksLocalizations.of(context)
              .hasKey("level_msg_${world}_$level")) {
            Timer(Duration(milliseconds: 400), () {
              TutorialDialog.show(context, world, level);
            });
          }
        }
      });
    }
  }

  void stopTimeGame() {
    if (_timerGame != null) {
      _timerGame.cancel();
      _timerGame = null;
    }
  }

  @override
  void dispose() {
    stopTimeGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameContainerViewModel>(
        converter: (store) => GameContainerViewModel.build(store, UserModule()),
        distinct: true,
        onInitialBuild: (viewModel) {
          viewModel.onLoadScreen();
          _gameContainerPrevViewModel.reload(viewModel.gameViewStatus.status);
          _showTutorialIfNeeded(viewModel);
        },
        onWillChange: (viewModel) {
          if (_gameContainerPrevViewModel.gameStatusChangeTo(
              viewModel.gameViewStatus.status, GameStatus.RESUME)) {
            viewModel.onChangeGameStatus(GameStatus.IDLE);
            if (viewModel.boardStatus.typeBoard == TypeBoardGame.LEVEL) {
              viewModel.onSaveLevel().then((_) {
                LevelSuccessDialog.show(
                      context, () => viewModel.onReloadLevel());
              });
            } else {
              GameSuccessDialog.show(context, viewModel);
            }
          }

          if (_gameContainerPrevViewModel.gameStatusChangeTo(
              viewModel.gameViewStatus.status, GameStatus.PLAYING)) {
            _showTutorialIfNeeded(viewModel);
          }

          _gameContainerPrevViewModel.reload(viewModel.gameViewStatus.status);
        },
        builder: (context, viewModel) {
          return Container(
            child: Stack(
              children: <Widget>[
                buildTopInfoContainer(viewModel),
                buildBoardContainer(viewModel),
                if (viewModel.boardStatus.typeBoard != TypeBoardGame.LEVEL)
                  buildClockContainer(viewModel)
              ],
            ),
          );
        });
  }

  Padding buildClockContainer(GameContainerViewModel viewModel) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: Dimensions.boardPaddingBottom(context)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: TheFinalCountdownWidget(
            sizeScreen: viewModel.sizeScreen,
            status: viewModel.gameViewStatus.status,
            seconds: viewModel.seconds,
            soundVolume: viewModel.soundVolume,
            orientation: TheFinalCountdownOrientation.HORIZONTAL,
            onCountdownStart: () {
              viewModel.onStartCountdown();
            },
            onTimeEnd: () {
              stopTimeGame();
              setState(() {
                _timerGame = viewModel.onStartGame();
              });
            },
          ),
        ));
  }

  Padding buildBoardContainer(GameContainerViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(
          top: Dimensions.infoHeightContainer(viewModel.sizeScreen)),
      child: RoundedContainer(
        bgColor: ResColors.colorTile1,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.bottomLeft,
                child: CubesBackground(
                  height: 160,
                )),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    top: (viewModel.boardStatus.typeBoard ==
                                TypeBoardGame.ARCADE ||
                            (viewModel.boardStatus.typeBoard ==
                                    TypeBoardGame.LEVEL &&
                                viewModel.boardStatus.assistance != null))
                        ? Dimensions.paddingTopBoardWithBarAssistance
                        : Dimensions.paddingTopBoard,
                    bottom: viewModel.boardStatus.typeBoard !=
                            TypeBoardGame.LEVEL
                        ? Dimensions.clockHeight(context, viewModel.sizeScreen)
                        : Dimensions.boardPaddingBottom(context)),
                child:
                    viewModel.gameViewStatus.status == GameStatus.CHANGING_LEVEL
                        ? NewLevelPanel()
                        : Board(
                            twoPlayers: false,
                            playersGame: PlayersGame.ONE,
                          )),
          ],
        ),
      ),
    );
  }

  RoundedContainer buildTopInfoContainer(GameContainerViewModel viewModel) {
    return RoundedContainer(
      color: ResColors.colorTile1,
      child: viewModel.boardStatus.typeBoard == TypeBoardGame.LEVEL
          ? TopInfoLevelLayout(
              sizeScreen: viewModel.sizeScreen,
              boardStatus: viewModel.boardStatus,
              scoreCounterColorsLevel: viewModel.scoreCounterColorsLevel)
          : FutureBuilder<int>(
              future: viewModel.record(),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return snapshot?.data != null
                    ? viewModel.boardStatus.typeBoard == TypeBoardGame.CLASSIC
                        ? TopInfoClassicLayout(
                            sizeScreen: viewModel.sizeScreen,
                            record: snapshot.data,
                            points: viewModel.points,
                            moves: viewModel.boardStatus.moves,
                          )
                        : TopInfoArcadeLayout(
                            sizeScreen: viewModel.sizeScreen,
                            record: snapshot.data,
                            points: viewModel.points,
                            scoreCounterColorsLevel:
                                viewModel.scoreCounterColorsLevel)
                    : SizedBox.shrink();
              },
            ),
      padding: EdgeInsets.only(top: 14),
    );
  }
}
