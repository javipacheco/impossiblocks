import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final gameViewStateReducer = combineReducers<GameViewStatus>([
  TypedReducer<GameViewStatus, ChangeStatusGameAction>(_changeStatusGame),
  TypedReducer<GameViewStatus, ChangeSizeBoardGameAction>(_changeSizeBoardGame),
]);

GameViewStatus _changeStatusGame(
    GameViewStatus game, ChangeStatusGameAction action) {
  return game.copyWith(status: action.status);
}

GameViewStatus _changeSizeBoardGame(
    GameViewStatus game, ChangeSizeBoardGameAction action) {
  return game.copyWith(sizeBoardGame: action.sizeBoardGame);
}