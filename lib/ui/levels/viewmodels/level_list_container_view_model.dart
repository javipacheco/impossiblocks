import 'package:flutter/widgets.dart';
import 'package:impossiblocks/navigation/routes.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:impossiblocks/utils/game_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/modules/modules.dart';
import "package:equatable/equatable.dart";

class LevelListContainerViewModel extends Equatable {
  final LevelListState levels;
  final SizeScreen sizeScreen;
  final bool loading;
  final Function() onInitialLevels;
  final Function(int) onLoadWorld;
  final Function(BuildContext, LevelState) onLevelClick;

  LevelListContainerViewModel({
    @required this.levels,
    @required this.sizeScreen,
    @required this.loading,
    @required this.onInitialLevels,
    @required this.onLoadWorld,
    @required this.onLevelClick,
  }) : super([levels, loading]);

  static build(Store<AppState> store, UserModule userModule) {
    void fillWorldsCompleted(List<LevelRepository> levelsRepository) {
      store.dispatch(FillCompletedWorldsAction(
          completed: GameUtils.getWorldsCompleted(
              levelsRepository, store.state.levels.worlds)));
    }

    void loadLevels(List<LevelRepository> levelsRepository) {
      store.dispatch(LoadLevelsAction(
          levels: GameUtils.getLevels(
              levelsRepository, store.state.levels.worlds)));
    }

    DebugUtils.debugPrint(
        "LevelListContainerViewModel => build: ${DateTime.now()}");
    return LevelListContainerViewModel(
      levels: store.state.levels,
      sizeScreen: store.state.preferences.sizeScreen,
      loading: store.state.levels.loading,
      onInitialLevels: () async {
        WorldListEntity worlds = await userModule.entityService.loadWorlds();
        store.dispatch(LoadWorldsAction(worlds: worlds));
        List<LevelRepository> levelsRepository = await userModule.getLevels();
        fillWorldsCompleted(levelsRepository);
        loadLevels(levelsRepository);
      },
      onLoadWorld: (world) async {
        store.dispatch(CurrentWorldsAction(world: world + 1));
      },
      onLevelClick: (BuildContext context, LevelState level) {
        store.dispatch(SetCurrentLevelAction(level: level.number));

        store.dispatch(ChangeStatusGameAction(status: GameStatus.PLAYING));

        userModule.entityService
            .loadLevel(level.world, level.number)
            .then((level) {

          TypeTile typeTile = level.randomBoard != null
              ? GameUtils.getTypeTile(level.randomBoard.typeTile)
              : TypeTile.NORMAL;
          int difficulty =
              level.randomBoard != null ? level.randomBoard.difficulty : 1;
          store.dispatch(LoadLevelInBoardAction(playersGame: PlayersGame.ONE,
              level: level, typeTile: typeTile, difficulty: difficulty));
          if (level.counters != null && level.counters.length == 2)
            store.dispatch(UpdateScoreColorLevelAction(
                color1: level.counters[0], color2: level.counters[1]));
          Navigator.pushNamed(context, ImpossiblocksRoutes.levelsGame);
        });
      },
    );
  }
}
