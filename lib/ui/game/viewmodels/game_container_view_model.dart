import 'dart:async';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/modules/user_module.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:impossiblocks/utils/game_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:flutter/widgets.dart';
import "package:equatable/equatable.dart";

class GameContainerViewModel extends Equatable {
  final bool premium;

  final GameViewStatus gameViewStatus;

  final UserState currentUser;

  final LevelListState levelListState;

  final BoardStatus boardStatus;

  final int points;

  final int seconds;

  final int soundVolume;

  final bool userVisitedStore;

  final SizeScreen sizeScreen;

  final Future<int> Function() record;

  final ScoreCounterColorsLevel scoreCounterColorsLevel;

  final Function(GameStatus) onChangeGameStatus;

  final Function() onLoadScreen;

  // Classic and Arcade Mode

  final Function() onStartCountdown;

  final Timer Function() onStartGame;

  final Function(bool) onReloadGame;

  final Future<bool> Function() onUpdateRecordGame;

  // Levels Mode

  final Function() onNextLevel;

  final Function() onReloadLevel;

  final Future<void> Function() onSaveLevel;

  final Future<bool> Function() levelCompleted;

  GameContainerViewModel({
    @required this.premium,
    @required this.gameViewStatus,
    @required this.currentUser,
    @required this.levelListState,
    @required this.boardStatus,
    @required this.points,
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
    @required this.onUpdateRecordGame,
    @required this.onNextLevel,
    @required this.onReloadLevel,
    @required this.onSaveLevel,
    @required this.levelCompleted,
  }) : super([
          premium,
          gameViewStatus,
          levelListState,
          points,
          seconds,
          boardStatus,
          scoreCounterColorsLevel,
          soundVolume,
          userVisitedStore,
          sizeScreen,
        ]);

  static build(Store<AppState> store, UserModule userModule) {
    DebugUtils.debugPrint("GameContainerViewModel => build: ${DateTime.now()}");
    return GameContainerViewModel(
      premium: store.state.purchase.premium,
      gameViewStatus: store.state.gameViewStatus,
      currentUser: store.state.users.current,
      levelListState: store.state.levels,
      boardStatus: store.state.board,
      points: store.state.score.points,
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
        switch (store.state.board.typeBoard) {
          case TypeBoardGame.ARCADE:
            store.dispatch(ResetScoreColorLevelAction());
            break;
          default:
            break;
        }
      },
      onStartCountdown: () {
        store.dispatch(ChangeStatusGameAction(status: GameStatus.COUNTDOWN));
      },
      onStartGame: () {
        SoundController.instance
            .playMusic(store.state.preferences.musicVolume, 1.0);
        store.dispatch(ResetScoreAction());
        store.dispatch(ResetAllMovesAction(playersGame: PlayersGame.ONE));
        store.dispatch(RandomBoardAction(playersGame: PlayersGame.ONE));
        store.dispatch(ChangeStatusGameAction(status: GameStatus.PLAYING));
        switch (store.state.board.typeBoard) {
          case TypeBoardGame.ARCADE:
            store.dispatch(ResetScoreColorLevelAction());
            GameUtils.createArcadeLevel(store, 1);
            break;
          default:
            break;
        }
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
      onUpdateRecordGame: () async {
        return userModule.updatePoints(
            store.state.board.getLeadboardGames(), store.state.score.points);
      },
      onNextLevel: () {
        int currentWorld = store.state.levels.currentWorld;
        int nextLevel = store.state.levels.currentLevel + 1;

        LevelState level = store.state.levels.levels.firstWhere(
            (level) => level.number == nextLevel,
            orElse: () => null);

        if (level != null) {
          store.dispatch(SetCurrentLevelAction(level: level.number));

          store.dispatch(ChangeStatusGameAction(status: GameStatus.PLAYING));

          userModule.entityService
              .loadLevel(currentWorld, level.number)
              .then((level) {
            if (level.counters != null && level.counters.length == 2)
              store.dispatch(UpdateScoreColorLevelAction(
                  color1: level.counters[0], color2: level.counters[1]));
            TypeTile typeTile = level.randomBoard != null
                ? GameUtils.getTypeTile(level.randomBoard.typeTile)
                : TypeTile.NORMAL;
            int difficulty =
                level.randomBoard != null ? level.randomBoard.difficulty : 1;
            store.dispatch(LoadLevelInBoardAction(
                playersGame: PlayersGame.ONE,
                level: level,
                typeTile: typeTile,
                difficulty: difficulty));
          });
        }
      },
      onReloadLevel: () {
        int currentWorld = store.state.levels.currentWorld;
        int currentLevel = store.state.levels.currentLevel;

        LevelState level = store.state.levels.levels.firstWhere(
            (level) => level.number == currentLevel,
            orElse: () => null);

        if (level != null) {
          store.dispatch(ChangeStatusGameAction(status: GameStatus.PLAYING));

          userModule.entityService
              .loadLevel(currentWorld, level.number)
              .then((level) {
            if (level.counters != null && level.counters.length == 2)
              store.dispatch(UpdateScoreColorLevelAction(
                  color1: level.counters[0], color2: level.counters[1]));
            TypeTile typeTile = level.randomBoard != null
                ? GameUtils.getTypeTile(level.randomBoard.typeTile)
                : TypeTile.NORMAL;
            int difficulty =
                level.randomBoard != null ? level.randomBoard.difficulty : 1;
            store.dispatch(LoadLevelInBoardAction(
                playersGame: PlayersGame.ONE,
                level: level,
                typeTile: typeTile,
                difficulty: difficulty));
          });
        }
      },
      onSaveLevel: () async {
        int currentWorld = store.state.levels.currentWorld;

        await userModule.saveLevel(currentWorld,
            store.state.levels.currentLevel, store.state.board.allMoves);

        List<LevelRepository> levelsRepository = await userModule.getLevels();

        store.dispatch(FillCompletedWorldsAction(
            completed: GameUtils.getWorldsCompleted(
                levelsRepository, store.state.levels.worlds)));

        store.dispatch(LoadLevelsAction(
            levels: GameUtils.getLevels(
                levelsRepository, store.state.levels.worlds)));
      },
      levelCompleted: () {
        return userModule.repositoryService
            .getLevel(
                store.state.users.current.id,
                store.state.levels.currentWorld,
                store.state.levels.currentLevel)
            .then((l) => l != null);
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

  bool gameStatusChangeTo(GameStatus viewModelStatus, GameStatus gameStatus) {
    return _gameStatus != viewModelStatus && viewModelStatus == gameStatus;
  }
}
