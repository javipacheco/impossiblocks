class UpdateScoreColorLevelAction {
  final int color1;

  final int color2;

  UpdateScoreColorLevelAction({this.color1, this.color2});

  @override
  String toString() {
    return 'UpdateScoreColorLevelAction{color1: $color1, color2: $color2}';
  }
}

class ResetScoreColorLevelAction {
  final int level;

  ResetScoreColorLevelAction({this.level = 1});

  @override
  String toString() {
    return 'ResetScoreColorLevelAction{level: $level}';
  }
}

/*
Subir de nivel en el modo Arcade
*/
class UpgradeScoreColorLevelAction {
  UpgradeScoreColorLevelAction();

  @override
  String toString() {
    return 'UpgradeScoreColorLevelAction{}';
  }
}

class SucessScoreColorLevelAction {
  final int color;

  SucessScoreColorLevelAction({this.color});

  @override
  String toString() {
    return 'SucessScoreColorLevelAction{color: $color}';
  }
}

/*
El usuario ha creado un error en el tablero y se penaliza. Normalmente sumando uno al contador
*/
class FailedScoreColorLevelAction {
  FailedScoreColorLevelAction();

  @override
  String toString() {
    return 'FailedScoreColorLevelAction{}';
  }
}
