import 'dart:async';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/modules/user_module.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:flutter/widgets.dart';
import "package:equatable/equatable.dart";

class TwoPlayersContainerViewModel extends Equatable {

  final bool premium;

  final GameViewStatus gameViewStatus;

  final UserState currentUser;

  final LevelListState levelListState;

  final BoardStatus boardStatus;

  final int points;

  final int pointsPlayerTwo;

  final int seconds;

  final int soundVolume;

  final bool userVisitedStore;

  final SizeScreen sizeScreen;

  final Future<int> Function() record;

  final ScoreCounterColorsLevel scoreCounterColorsLevel;

  final Function(GameStatus) onChangeGameStatus;

  final Function() onLoadScreen;

  final Function() onStartCountdown;

  final Timer Function() onStartGame;

  final Function(bool) onReloadGame;

  TwoPlayersContainerViewModel({
    @required this.premium,
    @required this.gameViewStatus,
    @required this.currentUser,
    @required this.levelListState,
    @required this.boardStatus,
    @required this.points,
    @required this.pointsPlayerTwo,
    @required this.seconds,
    @required this.soundVolume,
    @required this.userVisitedStore,
    @required this.sizeScreen,
    @required this.record,
    @required this.scoreCounterColorsLevel,
    @required this.onChangeGameStatus,
    @required this.onLoadScreen,
    @required this.onStartCountdown,
    @required this.onStartGame,
    @required this.onReloadGame,
  }) : super([
          premium,
          gameViewStatus,
          levelListState,
          points,
          pointsPlayerTwo,
          seconds,
          boardStatus,
          scoreCounterColorsLevel,
          soundVolume,
          userVisitedStore,
          sizeScreen,
        ]);

  static build(Store<AppState> store, UserModule userModule) {
    DebugUtils.debugPrint("GameContainerViewModel => build: ${DateTime.now()}");
    return TwoPlayersContainerViewModel(
      premium: store.state.purchase.premium,
      gameViewStatus: store.state.gameViewStatus,
      currentUser: store.state.users.current,
      levelListState: store.state.levels,
      boardStatus: store.state.board,
      points: store.state.score.points,
      pointsPlayerTwo: store.state.score.pointsPlayerTwo,
      seconds: store.state.score.seconds,
      soundVolume: store.state.preferences.soundVolume,
      userVisitedStore: store.state.preferences.userVisitedStore,
      sizeScreen: store.state.preferences.sizeScreen,
      record: () => userModule.localPreferencesService
          .getRecord(store.state.board.getLeadboardGames()),
      scoreCounterColorsLevel: store.state.scoreCounterColorsLevel,
      onChangeGameStatus: (GameStatus status) {
        store.dispatch(ChangeStatusGameAction(status: status));
      },
      onLoadScreen: () {
        store.dispatch(ResetScoreAction());
        store.dispatch(ResetAllMovesAction(playersGame: PlayersGame.ONE));
        store.dispatch(ResetAllMovesAction(playersGame: PlayersGame.TWO));
      },
      onStartCountdown: () {
        store.dispatch(ChangeStatusGameAction(status: GameStatus.COUNTDOWN));
      },
      onStartGame: () {
        SoundController.instance.playMusic(store.state.preferences.musicVolume, 1.0);
        store.dispatch(ResetScoreAction());
        store.dispatch(ResetAllMovesAction(playersGame: PlayersGame.ONE));
        store.dispatch(ResetAllMovesAction(playersGame: PlayersGame.TWO));
        store.dispatch(RandomBoardAction(playersGame: PlayersGame.ONE));
        store.dispatch(RandomBoardAction(playersGame: PlayersGame.TWO));
        store.dispatch(ChangeStatusGameAction(status: GameStatus.PLAYING));
        
        return Timer.periodic(Duration(seconds: 1), (timer) {
          if (store.state.gameViewStatus.status == GameStatus.PLAYING) {
            store.dispatch(ReduceTimeToScoreAction());
            if (store.state.score.seconds <= 0) {
              SoundController.instance.stopMusic();
              timer.cancel();
              store.dispatch(ChangeStatusGameAction(status: GameStatus.RESUME));
            }
          }
        });
      },
      onReloadGame: (showAd) {
        store.dispatch(ChangeStatusGameAction(status: GameStatus.WAITING));
      },
    );
  }
}

class GameContainerPrevViewModel {
  GameStatus _gameStatus;

  GameContainerPrevViewModel();

  void reload(GameStatus viewModelStatus) {
    _gameStatus = viewModelStatus;
  }

  bool gameStatusChangeTo(
      GameStatus viewModelStatus, GameStatus gameStatus) {
    return _gameStatus != viewModelStatus &&
        viewModelStatus == gameStatus;
  }
}
