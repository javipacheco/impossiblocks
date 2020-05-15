import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';

class LoadWorldsAction {

  final WorldListEntity worlds;

  LoadWorldsAction({ this.worlds });

  @override
  String toString() {
    return 'LoadWorldsAction{worlds: $worlds}';
  }
}

class FillCompletedWorldsAction {

  final List<WorldsCompletedState> completed;

  FillCompletedWorldsAction({ this.completed });

  @override
  String toString() {
    return 'FillCompletedWorldsAction{completed: $completed}';
  }
}

class CurrentWorldsAction {

  final int world;

  CurrentWorldsAction({ this.world });

  @override
  String toString() {
    return 'CurrentWorldsAction{world: $world}';
  }
}

class LoadLevelsAction {

  final List<LevelState> levels;

  LoadLevelsAction({ this.levels });

  @override
  String toString() {
    return 'LoadLevelsAction{levels: $levels}';
  }
}

class SetCurrentLevelAction {
  final int level;

  SetCurrentLevelAction({this.level});

  @override
  String toString() {
    return 'SetCurrentLevelAction{level: $level}';
  }
}

class SpendCoinsLevelAction {
  final AssistanceActionType assistanceActionType;

  SpendCoinsLevelAction({this.assistanceActionType});

  @override
  String toString() {
    return 'SpendCoinsLevelAction{assistanceActionType: $assistanceActionType}';
  }
}
