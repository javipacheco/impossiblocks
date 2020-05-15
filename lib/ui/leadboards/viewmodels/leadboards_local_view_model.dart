import 'package:equatable/equatable.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/modules/modules.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';

class LeadboardsLocalViewModel extends Equatable {
  final SizeScreen sizeScreen;

  final UserState currentUser;

  final List<UserState> users;

  final Function(LeadboardGames) onLoadUsers;

  LeadboardsLocalViewModel({
    @required this.sizeScreen,
    @required this.currentUser,
    @required this.users,
    @required this.onLoadUsers,
  }) : super([sizeScreen, currentUser, users]);

  static build(Store<AppState> store) {

    UserModule userModule = UserModule();

    DebugUtils.debugPrint("LeadboardsLocalViewModel => build: ${DateTime.now()}");
    return LeadboardsLocalViewModel(
      sizeScreen: store.state.preferences.sizeScreen,
      currentUser: store.state.users.current,
      users: store.state.users.users,
      onLoadUsers: (leadboardGame) async {
        var userList = await userModule.getAllUsersRanked(leadboardGame);
        store.dispatch(LoadUsersAction(
              users: userList));
      },
    );
  }
}
