import 'package:equatable/equatable.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/modules/modules.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:flutter/widgets.dart';

class NewLevelPanelViewBoard extends Equatable {
  final SizeScreen sizeScreen;

  final UserState currentUser;

  final Score score;

  final int columms;

  final ScoreCounterColorsLevel scoreCounterColorsLevel;

  final int soundVolume;

  final Function(int) onAddCoins;

  final Function onPlayGame;

  final Function onFinishGame;

  NewLevelPanelViewBoard({
    @required this.sizeScreen,
    @required this.currentUser,
    @required this.score,
    @required this.columms,
    @required this.scoreCounterColorsLevel,
    @required this.soundVolume,
    @required this.onAddCoins,
    @required this.onPlayGame,
    @required this.onFinishGame,
  }) : super([currentUser, score, columms, scoreCounterColorsLevel, soundVolume]);

  static build(Store<AppState> store) {
    DebugUtils.debugPrint("NewLevelPanelViewBoard => build: ${DateTime.now()}");
    UserModule userModule = UserModule();

    Future<UserState> dispatchCurrentUser() {
      return userModule.getCurrentUser().then((user) {
        var userState = UserState.fromRepository(user);
        store.dispatch(LoadCurrentUserAction(user: userState));
        return userState;
      });
    }

    return NewLevelPanelViewBoard(
        sizeScreen: store.state.preferences.sizeScreen,
        currentUser: store.state.users.current,
        score: store.state.score,
        columms: store.state.board.columns,
        scoreCounterColorsLevel: store.state.scoreCounterColorsLevel,
        soundVolume: store.state.preferences.soundVolume,
        onAddCoins: (coins) async {
          await userModule.repositoryService
              .addCoinsToUser(store.state.users.current.id, coins);
          dispatchCurrentUser();
        },
        onPlayGame: () {
          store.dispatch(ChangeStatusGameAction(status: GameStatus.PLAYING));
        },
        onFinishGame: () {
          store.dispatch(ChangeStatusGameAction(status: GameStatus.RESUME));
        });
  }
}
