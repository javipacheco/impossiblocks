import 'package:impossiblocks/utils/game_utils.dart';
import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final levelsStateReducer = combineReducers<LevelListState>([
  TypedReducer<LevelListState, LoadWorldsAction>(_loadWorlds),
  TypedReducer<LevelListState, FillCompletedWorldsAction>(_fillCompletedWorlds),
  TypedReducer<LevelListState, CurrentWorldsAction>(_currentWorlds),
  TypedReducer<LevelListState, SetCurrentLevelAction>(_loadCurrentLevel),
  TypedReducer<LevelListState, LoadLevelsAction>(_loadLevels),
  TypedReducer<LevelListState, LoadLevelInBoardAction>(_loadLevelInBoard),
  TypedReducer<LevelListState, SpendCoinsLevelAction>(_spendCoinsLevel),
]);

LevelListState _loadLevelInBoard(
    LevelListState levels, LoadLevelInBoardAction action) {
  return levels.copyWith(coins: action.level.assistance?.coins ?? 0);
}

LevelListState _loadWorlds(LevelListState levels, LoadWorldsAction action) {
  List<WorldsState> list = action.worlds.worlds
      .map((w) => WorldsState(name: w.name, world: w.world, levels: w.levels))
      .toList();
  return levels.copyWith(worlds: list);
}

LevelListState _fillCompletedWorlds(
    LevelListState levels, FillCompletedWorldsAction action) {
  return levels.copyWith(worldsCompleted: action.completed);
}

LevelListState _currentWorlds(
    LevelListState levels, CurrentWorldsAction action) {
  return levels.copyWith(currentWorld: action.world);
}

LevelListState _loadCurrentLevel(
    LevelListState levels, SetCurrentLevelAction action) {
  return levels.copyWith(currentLevel: action.level);
}

LevelListState _loadLevels(LevelListState levels, LoadLevelsAction action) {
  return levels.copyWith(levels: action.levels);
}

LevelListState _spendCoinsLevel(
    LevelListState levels, SpendCoinsLevelAction action) {
  int coins = levels.coins - GameUtils.getCoinsFor(action.assistanceActionType);
  return levels.copyWith(coins: coins);
}
