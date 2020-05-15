import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final scoreCounterColorLevelStateReducer = combineReducers<ScoreCounterColorsLevel>([
  TypedReducer<ScoreCounterColorsLevel, UpdateScoreColorLevelAction>(_updateScoreColorLevel),
  TypedReducer<ScoreCounterColorsLevel, SucessScoreColorLevelAction>(_sucessScoreColorLevel),
  TypedReducer<ScoreCounterColorsLevel, UpgradeScoreColorLevelAction>(_upgradeScoreColorLevel),
  TypedReducer<ScoreCounterColorsLevel, ResetScoreColorLevelAction>(_resetScoreColorLevel),
  TypedReducer<ScoreCounterColorsLevel, FailedScoreColorLevelAction>(_failedScoreColorLevel),
]);

ScoreCounterColorsLevel _updateScoreColorLevel(
    ScoreCounterColorsLevel score, UpdateScoreColorLevelAction action) {
  return score.copyWith(color1: action.color1, color2: action.color2);
}

ScoreCounterColorsLevel _sucessScoreColorLevel(
    ScoreCounterColorsLevel score, SucessScoreColorLevelAction action) {
  return score.succesColor(action.color);
}

ScoreCounterColorsLevel _upgradeScoreColorLevel(
    ScoreCounterColorsLevel score, UpgradeScoreColorLevelAction action) {
  return score.upgradeLevel();
}

ScoreCounterColorsLevel _resetScoreColorLevel(
    ScoreCounterColorsLevel score, ResetScoreColorLevelAction action) {
  return score.resetLevel(action.level);
}

ScoreCounterColorsLevel _failedScoreColorLevel(
    ScoreCounterColorsLevel score, FailedScoreColorLevelAction action) {
  return score.failedLevel();
}