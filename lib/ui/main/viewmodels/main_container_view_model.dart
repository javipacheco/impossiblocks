import 'package:equatable/equatable.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/modules/user_module.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:impossiblocks/utils/game_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';

class MainContainerViewModel extends Equatable {
  final Function() onInitialLevels;

  final bool Function(int) isLevelCompleted;

  final int Function() countLevelCompleted;

  final SizeBoardGame boardSelected;

  final SizeScreen sizeScreen;

  final GameViewStatus Function() gameViewStatus;

  final int Function(TypeBoardGame) onUserRank;

  final Function() onLoadClassicGame;

  final Function() onLoadArcadeGame;

  final Function() onLoadTwoPlayersGame;

  final Function() onLoadSizeBoard;

  final Function(SizeBoardGame) onChangeSizeBoard;

  MainContainerViewModel({
    @required this.onInitialLevels,
    @required this.isLevelCompleted,
    @required this.countLevelCompleted,
    @required this.boardSelected,
    @required this.sizeScreen,
    @required this.gameViewStatus,
    @required this.onUserRank,
    @required this.onLoadClassicGame,
    @required this.onLoadArcadeGame,
    @required this.onLoadTwoPlayersGame,
    @required this.onLoadSizeBoard,
    @required this.onChangeSizeBoard,
  }) : super([boardSelected, sizeScreen]);

  static build(Store<AppState> store, UserModule userModule) {
    DebugUtils.debugPrint("MainContainerViewModel => build: ${DateTime.now()}");
    return MainContainerViewModel(
      onInitialLevels: () async {
        WorldListEntity worlds = await userModule.entityService.loadWorlds();
        store.dispatch(LoadWorldsAction(worlds: worlds));
        List<LevelRepository> levelsRepository = await userModule.getLevels();
        store.dispatch(FillCompletedWorldsAction(
            completed: GameUtils.getWorldsCompleted(
                levelsRepository, store.state.levels.worlds)));
      },
      isLevelCompleted: (level) {
        return store.state.levels.worldsCompleted != null &&
            store.state.levels.worldsCompleted.length > level &&
            store.state.levels.worldsCompleted[level].completed;
      },
      countLevelCompleted: () {
        if (store.state.levels.worldsCompleted != null) {
          return store.state.levels.worldsCompleted
              .where((w) => w.completed)
              .length;
        } else {
          return 0;
        }
      },
      boardSelected: store.state.preferences.boardSelected,
      sizeScreen: store.state.preferences.sizeScreen,
      gameViewStatus: () => store.state.gameViewStatus,
      onUserRank: (typeBoardGame) {
        LeadboardGames leadboardGame = LeadboardGames.X3_3_CLASSIC;
        if (store.state.gameViewStatus.sizeBoardGame == SizeBoardGame.X4_4 &&
            typeBoardGame == TypeBoardGame.CLASSIC) {
          leadboardGame = LeadboardGames.X4_4_CLASSIC;
        } else if (store.state.gameViewStatus.sizeBoardGame ==
                SizeBoardGame.X5_5 &&
            typeBoardGame == TypeBoardGame.CLASSIC) {
          leadboardGame = LeadboardGames.X5_5_CLASSIC;
        } else if (store.state.gameViewStatus.sizeBoardGame ==
                SizeBoardGame.X3_3 &&
            typeBoardGame == TypeBoardGame.ARCADE) {
          leadboardGame = LeadboardGames.X3_3_ARCADE;
        } else if (store.state.gameViewStatus.sizeBoardGame ==
                SizeBoardGame.X4_4 &&
            typeBoardGame == TypeBoardGame.ARCADE) {
          leadboardGame = LeadboardGames.X4_4_ARCADE;
        } else if (store.state.gameViewStatus.sizeBoardGame ==
                SizeBoardGame.X5_5 &&
            typeBoardGame == TypeBoardGame.ARCADE) {
          leadboardGame = LeadboardGames.X5_5_ARCADE;
        }
        return store.state.users.getRank(leadboardGame);
      },
      onLoadClassicGame: () {
        store.dispatch(ChangeStatusGameAction(status: GameStatus.WAITING));
        store.dispatch(LoadClassicInBoardAction(
            playersGame: PlayersGame.ONE,
            sizeBoardGame: store.state.gameViewStatus.sizeBoardGame));
      },
      onLoadArcadeGame: () {
        store.dispatch(ChangeStatusGameAction(status: GameStatus.WAITING));
        store.dispatch(LoadArcadeInBoardAction(
            playersGame: PlayersGame.ONE,
            sizeBoardGame: store.state.gameViewStatus.sizeBoardGame));
      },
      onLoadTwoPlayersGame: () {
        store.dispatch(ChangeStatusGameAction(status: GameStatus.WAITING));
        store.dispatch(LoadClassicInBoardAction(
            playersGame: PlayersGame.ONE,
            sizeBoardGame: store.state.gameViewStatus.sizeBoardGame));
        store.dispatch(LoadClassicInBoardAction(
            playersGame: PlayersGame.TWO,
            sizeBoardGame: store.state.gameViewStatus.sizeBoardGame));
      },
      onLoadSizeBoard: () {
        store.dispatch(ChangeSizeBoardGameAction(
            sizeBoardGame: store.state.preferences.boardSelected));
      },
      onChangeSizeBoard: (SizeBoardGame sizeBoardGame) {
        store.dispatch(BoardSelectedPreferencesAction(board: sizeBoardGame));
        store.dispatch(ChangeSizeBoardGameAction(sizeBoardGame: sizeBoardGame));
      },
    );
  }
}
