import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/modules/modules.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/game/board.dart';
import 'package:impossiblocks/ui/game/the_final_countdown.dart';
import 'package:impossiblocks/ui/two_players/viewmodels/two_players_view_model.dart';

class TwoPlayersContainer extends StatefulWidget {
  TwoPlayersContainer({Key key}) : super(key: key);

  @override
  _TwoPlayersContainerState createState() => _TwoPlayersContainerState();
}

class _TwoPlayersContainerState extends State<TwoPlayersContainer> {
  Timer _timerGame;
  bool _showFinalMessage;
  @override
  void initState() {
    super.initState();
    _showFinalMessage = false;
    _timerGame = null;
  }

  GameContainerPrevViewModel _gameContainerPrevViewModel =
      GameContainerPrevViewModel();

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
    return StoreConnector<AppState, TwoPlayersContainerViewModel>(
        converter: (store) =>
            TwoPlayersContainerViewModel.build(store, UserModule()),
        distinct: true,
        onInitialBuild: (viewModel) {
          viewModel.onLoadScreen();
          _gameContainerPrevViewModel.reload(viewModel.gameViewStatus.status);
        },
        onWillChange: (viewModel) {
          if (_gameContainerPrevViewModel.gameStatusChangeTo(
              viewModel.gameViewStatus.status, GameStatus.RESUME)) {
            viewModel.onChangeGameStatus(GameStatus.WAITING);
            setState(() {
              _showFinalMessage = true;
            });
          }

          _gameContainerPrevViewModel.reload(viewModel.gameViewStatus.status);
        },
        builder: (context, viewModel) {
          return Padding(
            padding: EdgeInsets.only(top: 25),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildBoardContainer(viewModel, PlayersGame.ONE),
                      Divider(
                        color: Colors.grey,
                        height: 2,
                      ),
                      buildBoardContainer(viewModel, PlayersGame.TWO),
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey,
                  width: 2,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            buildPlayerPoints(viewModel, viewModel.points,
                                viewModel.pointsPlayerTwo),
                            buildClockContainer(viewModel),
                            buildPlayerPoints(viewModel,
                                viewModel.pointsPlayerTwo, viewModel.points)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget buildPlayerPoints(TwoPlayersContainerViewModel viewModel, int points,
      int pointOtherPlayer) {
    double startButtonSize = Dimensions.startButtonHeight(viewModel.sizeScreen);
    return RotatedBox(
      quarterTurns: 1,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        constraints: BoxConstraints.expand(
          width: startButtonSize,
          height: startButtonSize,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: points > pointOtherPlayer
              ? Colors.green
              : pointOtherPlayer > points ? Colors.red : Colors.orange,
        ),
        child: Center(
            child: Text(
          points.toString(),
          style: ResStyles.big(viewModel.sizeScreen),
        )),
      ),
    );
  }

  Widget buildClockContainer(TwoPlayersContainerViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TheFinalCountdownWidget(
        sizeScreen: viewModel.sizeScreen,
        status: viewModel.gameViewStatus.status,
        seconds: viewModel.seconds,
        soundVolume: viewModel.soundVolume,
        orientation: TheFinalCountdownOrientation.VERTICAL,
        onCountdownStart: () {
          viewModel.onStartCountdown();
        },
        onTimeEnd: () {
          stopTimeGame();
          setState(() {
            _showFinalMessage = false;
            _timerGame = viewModel.onStartGame();
          });
        },
      ),
    );
  }

  Widget buildBoardContainer(
      TwoPlayersContainerViewModel viewModel, PlayersGame playersGame) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Board(
                twoPlayers: true,
                playersGame: playersGame,
              )),
          if (_showFinalMessage)
            Center(
                child: RotatedBox(
              quarterTurns: playersGame == PlayersGame.ONE ? 2 : 0,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  padding: EdgeInsets.all(16),
                  child: Text(
                    _getMessage(viewModel, playersGame),
                    style: ResStyles.twoPlayersWinOrLost(viewModel.sizeScreen),
                  )),
            ))
        ],
      ),
    );
  }

  String _getMessage(
      TwoPlayersContainerViewModel viewModel, PlayersGame playersGame) {
    if (playersGame == PlayersGame.ONE) {
      return viewModel.points > viewModel.pointsPlayerTwo
          ? ImpossiblocksLocalizations.of(context).text("you_win").toUpperCase()
          : viewModel.points < viewModel.pointsPlayerTwo
              ? ImpossiblocksLocalizations.of(context)
                  .text("you_lost")
                  .toUpperCase()
              : ImpossiblocksLocalizations.of(context)
                  .text("tie")
                  .toUpperCase();
    } else {
      return viewModel.points < viewModel.pointsPlayerTwo
          ? ImpossiblocksLocalizations.of(context).text("you_win").toUpperCase()
          : viewModel.points > viewModel.pointsPlayerTwo
              ? ImpossiblocksLocalizations.of(context)
                  .text("you_lost")
                  .toUpperCase()
              : ImpossiblocksLocalizations.of(context)
                  .text("tie")
                  .toUpperCase();
    }
  }
}
