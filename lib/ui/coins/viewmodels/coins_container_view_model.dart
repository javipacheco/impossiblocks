import 'package:equatable/equatable.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/actions/users_actions.dart';
import 'package:impossiblocks/modules/user_module.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';

class CoinsContainerViewModel extends Equatable {
  final UserState currentUser;

  final int soundVolume;

  final SizeScreen sizeScreen;

  final Function(int) onAddCoins;

  final Function() onVisitedStore;

  CoinsContainerViewModel({
    @required this.currentUser,
    @required this.soundVolume,
    @required this.sizeScreen,
    @required this.onAddCoins,
    @required this.onVisitedStore,
  }) : super([currentUser, soundVolume, sizeScreen]);

  static build(Store<AppState> store) {
    UserModule userModule = UserModule();

    Future<UserState> dispatchCurrentUser() {
      return userModule.getCurrentUser().then((user) {
        var userState = UserState.fromRepository(user);
        store.dispatch(LoadCurrentUserAction(user: userState));
        return userState;
      });
    }

    DebugUtils.debugPrint("CoinsContainerViewModel => build: ${DateTime.now()}");
    return CoinsContainerViewModel(
      currentUser: store.state.users.current,
      sizeScreen: store.state.preferences.sizeScreen,
      soundVolume: store.state.preferences.soundVolume,
      onAddCoins: (coins) async {
        await userModule.repositoryService.addCoinsToUser(store.state.users.current.id, coins);
        dispatchCurrentUser();
      },
      onVisitedStore: () {
        store.dispatch(UserVisitedStorePreferencesAction());
      }
    );
  }
}
