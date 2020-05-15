import 'package:impossiblocks/models/models.dart';
import 'users_reducer.dart';
import 'score_reducer.dart';
import 'board_player_one_reducer.dart';
import 'board_player_two_reducer.dart';
import 'game_view_reducer.dart';
import 'levels_reducer.dart';
import 'preferences_reducer.dart';
import 'score_counter_color_level_reducer.dart';
import 'users_play_games_reducer.dart';
import 'purchase_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    users: usersStateReducer(state.users, action),
      preferences: preferentesStateReducer(state.preferences, action),
      purchase: purchaseStateReducer(state.purchase, action),
      usersPlayGames: usersPlayGamesStateReducer(state.usersPlayGames, action),
      score: scoreStateReducer(state.score, action),
      scoreCounterColorsLevel: scoreCounterColorLevelStateReducer(
          state.scoreCounterColorsLevel, action),
      board: boardPlayerOneStateReducer(state.board, action),
      boardPlayerTwo: boardPlayerTwoStateReducer(state.boardPlayerTwo, action),
      gameViewStatus: gameViewStateReducer(state.gameViewStatus, action),
      levels: levelsStateReducer(state.levels, action));
}
