import 'package:impossiblocks/actions/board_actions.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';
import 'package:redux/redux.dart';
import 'dart:math';

class GameUtils {
  static const int maxTime = 120;

  static const int maxCountDownSteps = 5;

  static const int coinsForFireman = 5;

  static const int coinsForRay = 5;

  static const int coinsForBlock = 2;

  static const int coinsForBrush = 15;

  static TypeTile getTypeTile(String tt) {
    switch (tt) {
      case "fire":
        return TypeTile.FIRE;
        break;
      case "blocked":
        return TypeTile.BLOCKED;
        break;
      case "ray":
        return TypeTile.LIGHTNING;
        break;
      default:
        return TypeTile.NORMAL;
        break;
    }
  }

  static int getCoinsFor(AssistanceActionType assistanceActionType) {
    switch (assistanceActionType) {
      case AssistanceActionType.FIREMAN:
        return GameUtils.coinsForFireman;
        break;
      case AssistanceActionType.LIGHTNING:
        return GameUtils.coinsForRay;
        break;
      case AssistanceActionType.BRUSH1:
        return GameUtils.coinsForBrush;
        break;
      case AssistanceActionType.BRUSH2:
        return GameUtils.coinsForBrush;
        break;
      case AssistanceActionType.BLOCK:
        return GameUtils.coinsForBlock;
        break;
    }
    return 0;
  }

  static int getUserCoins(AppState state) {
    switch (state.board.typeBoard) {
      case TypeBoardGame.LEVEL:
        return state.levels.coins;
        break;
      case TypeBoardGame.ARCADE:
        return state.users.current.coins;
        break;
      default:
        return 0;
        break;
    }
  }

  static void createArcadeLevel(
      Store<AppState> store, int level) {
    TypeTile typeTile;
    int difficulty;
    if (level >= 4) {
      typeTile = level % 2 == 0 ? TypeTile.FIRE : TypeTile.LIGHTNING;
      difficulty = level - 3;
    }
    store.dispatch(RandomBoardAction(
        playersGame: PlayersGame.ONE, typeTile: typeTile, difficulty: difficulty));
    store.dispatch(LoadAssistanceAction(
      brush: AssistanceItemAction(afterMoves: 0, uses: min(level, 2)),
      block: AssistanceItemAction(afterMoves: level - 1),
      fireman: typeTile == TypeTile.FIRE
          ? AssistanceItemAction(afterMoves: difficulty)
          : null,
      ray: typeTile == TypeTile.LIGHTNING
          ? AssistanceItemAction(afterMoves: difficulty)
          : null,
    ));
  }

  static List<WorldsCompletedState> getWorldsCompleted(
      List<LevelRepository> levelsRepository, List<WorldsState> worlds) {
    return worlds.map((w) {
      var levelsByWorld = levelsRepository.where((l) => l.world == w.world);
      int levelsCompleted = levelsByWorld?.length ?? 0;
      return WorldsCompletedState(
          world: w.world,
          levelsCompleted: levelsCompleted,
          completed: levelsCompleted >= w.levels);
    }).toList();
  }

  static List<LevelState> getLevels(
      List<LevelRepository> levelsRepository, List<WorldsState> worlds) {
    return worlds
        .expand((world) =>
            List.generate(world.levels, (i) => i + 1).map((levelNumber) {
              var r = levelsRepository.where((level) =>
                  level.world == world.world && level.number == levelNumber);
              LevelRepository levelRepository =
                  (r != null && r.isNotEmpty) ? r.first : null;
              return levelRepository != null
                  ? LevelState(
                      world: world.world,
                      number: levelNumber,
                      stars: levelRepository.stars,
                      done: true)
                  : LevelState(
                      world: world.world,
                      number: levelNumber,
                      stars: 0,
                      done: false);
            }))
        .toList();
  }

  static String getTimeFormatted(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return "$m:${s.toString().padLeft(2, "0")}";
  }
}
