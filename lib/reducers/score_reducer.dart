import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final scoreStateReducer = combineReducers<Score>([
  TypedReducer<Score, AddPointToScoreAction>(_addPointToScore),
  TypedReducer<Score, RemovePointToScoreAction>(_removePointToScore),
  TypedReducer<Score, AddTimeToScoreAction>(_addTimeToScore),
  TypedReducer<Score, ReduceTimeToScoreAction>(_reduceTimeToScore),
  TypedReducer<Score, ResetScoreAction>(_resetScore),
  TypedReducer<Score, UpdateScoreForUpgradingLevelAction>(_updateScoreForUpgradingLevel),
  TypedReducer<Score, PauseAction>(_pause),
  TypedReducer<Score, ResumeAction>(_resume),
]);

Score _addPointToScore(
    Score score, AddPointToScoreAction action) {
  return score.addPoint(action.playersGame);
}

Score _removePointToScore(
    Score score, RemovePointToScoreAction action) {
  return score.removePoint(action.playersGame);
}

Score _addTimeToScore(
    Score score, AddTimeToScoreAction action) {
  return score.addTime(time: action.time);
}

Score _reduceTimeToScore(
    Score score, ReduceTimeToScoreAction action) {
  return score.reduceTime();
}

Score _updateScoreForUpgradingLevel(
    Score score, UpdateScoreForUpgradingLevelAction action) {
  return score.updateScoreForUpgradingLevel();
}

Score _resetScore(
    Score score, ResetScoreAction action) {
  return Score.reset();
}

Score _pause(
    Score score, PauseAction action) {
  return score.copyWith(pause: true);
}

Score _resume(
    Score score, ResumeAction action) {
  return score.copyWith(pause: false);
}
