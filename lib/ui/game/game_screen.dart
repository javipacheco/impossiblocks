import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/navigation/routes.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/ui/game/game_container.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/ui/game/viewmodels/game_container_view_model.dart';
import 'package:impossiblocks/ui/widgets/dialogs/pause_dialog.dart';
import 'package:impossiblocks/ui/widgets/title_app_bar.dart';
import 'package:impossiblocks/ui/widgets/dialogs/tutorial_dialog.dart';
import 'viewmodels/game_screen_view_model.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _isVisible;

  @override
  initState() {
    super.initState();
    _isVisible = true;
  }

  GameContainerPrevViewModel _gameContainerPrevViewModel =
      GameContainerPrevViewModel();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameScreenViewModel>(
        distinct: true,
        converter: (store) => GameScreenViewModel.build(store),
        onInitialBuild: (viewModel) {
          _gameContainerPrevViewModel.reload(viewModel.gameViewStatus);
        },
        onDispose: (store) {
          SoundController.instance.stopMusic();
        },
        onWillChange: (viewModel) {
          if (_gameContainerPrevViewModel.gameStatusChangeTo(
              viewModel.gameViewStatus, GameStatus.COUNTDOWN)) {
            setState(() {
              _isVisible = false;
            });
          }
          if (_gameContainerPrevViewModel.gameStatusChangeTo(
              viewModel.gameViewStatus, GameStatus.WAITING)) {
            setState(() {
              _isVisible = true;
            });
          }
          _gameContainerPrevViewModel.reload(viewModel.gameViewStatus);
        },
        builder: (context, viewModel) {
          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                        viewModel.boardStatus.typeBoard == TypeBoardGame.LEVEL
                            ? Icons.info_outline
                            : Icons.pause),
                    disabledColor: Colors.blueGrey,
                    onPressed: viewModel.boardStatus.typeBoard ==
                            TypeBoardGame.LEVEL
                        ? ImpossiblocksLocalizations.of(context).hasKey(
                                "level_msg_${viewModel.levels.currentWorld}_${viewModel.levels.currentLevel}")
                            ? () => TutorialDialog.show(
                                context,
                                viewModel.levels.currentWorld,
                                viewModel.levels.currentLevel)
                            : null
                        : viewModel.gameViewStatus == GameStatus.PLAYING
                            ? () {
                                viewModel.onPause();
                                PauseDialog.show(context, () {
                                  viewModel.onResume();
                                });
                              }
                            : null,
                  ),
                ],
                title: Center(
                    child: new TitleAppBar(
                        title: viewModel.boardStatus.typeBoard ==
                                TypeBoardGame.LEVEL
                            ? "${ImpossiblocksLocalizations.of(context).text("level")}: ${viewModel.levels.currentWorld} - ${viewModel.levels.currentLevel}"
                            : viewModel.boardStatus.typeBoard ==
                                    TypeBoardGame.ARCADE
                                ? ImpossiblocksLocalizations.of(context)
                                    .text("arcade")
                                : ImpossiblocksLocalizations.of(context)
                                    .text("classic"))),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              floatingActionButton:
                  viewModel.boardStatus.typeBoard != TypeBoardGame.LEVEL
                      ? AnimatedOpacity(
                          opacity: _isVisible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context,
                                  viewModel.boardStatus.typeBoard ==
                                          TypeBoardGame.ARCADE
                                      ? ImpossiblocksRoutes.howToPlayArcade
                                      : ImpossiblocksRoutes.howToPlayClassic);
                            },
                            tooltip: "How to play",
                            child: SvgPicture.asset(
                              "assets/images/ic_tutorial.svg",
                              color: Colors.white,
                              width: 30,
                              height: 30,
                            ),
                            backgroundColor: ResColors.colorTile2,
                          ),
                        )
                      : null,
              body: GameContainer(),
            ),
          );
        });
  }
}
