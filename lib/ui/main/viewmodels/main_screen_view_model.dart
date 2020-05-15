import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/modules/modules.dart';
import 'package:impossiblocks/services/local_preferences_service.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:impossiblocks/utils/game_utils.dart';
import 'package:impossiblocks/utils/size_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';

class MainScreenViewModel extends Equatable {
  final SizeScreen sizeScreen;

  final UserState currentUser;

  final List<UserState> users;

  final bool isPremium;

  final int soundVolume;

  final int musicVolume;

  final bool userChangedEntering;

  final bool userRemoveAnimations;

  final Function() userWasChangedEntering;

  final Function() onUserRemoveAnimations;

  final Function() changeSoundVolume;

  final Function() changeMusicVolume;

  final Function() onLoadUsers;

  final Function(String, int) onAddUser;

  final Function(int) onSelectUser;

  final Function(String, int) onUpdateCurrentUserFirstTime;

  final Function(int, String, int) onUpdateUser;

  final Function(int) onDeleteUser;

  final Function() onAddingLevels;

  final Function(BuildContext) onReloadSizeScreen;

  MainScreenViewModel({
    @required this.sizeScreen,
    @required this.currentUser,
    @required this.users,
    @required this.isPremium,
    @required this.soundVolume,
    @required this.musicVolume,
    @required this.userChangedEntering,
    @required this.userRemoveAnimations,
    @required this.userWasChangedEntering,
    @required this.onUserRemoveAnimations,
    @required this.changeSoundVolume,
    @required this.changeMusicVolume,
    @required this.onLoadUsers,
    @required this.onAddUser,
    @required this.onSelectUser,
    @required this.onUpdateCurrentUserFirstTime,
    @required this.onUpdateUser,
    @required this.onDeleteUser,
    @required this.onAddingLevels,
    @required this.onReloadSizeScreen,
  }) : super([currentUser, users, isPremium, soundVolume, userChangedEntering]);

  static build(Store<AppState> store) {
    UserModule userModule = UserModule();
    Future<UserState> dispatchCurrentUser() {
      return userModule.getCurrentUser().then((user) {
        var userState = UserState.fromRepository(user);
        store.dispatch(LoadCurrentUserAction(user: userState));
        return userState;
      });
    }

    void dispatchUsers() {
      userModule.getAllUsers().then((users) {
        store.dispatch(LoadUsersAction(
            users:
                users.map((user) => UserState.fromRepository(user)).toList()));
      });
    }

    void dispatchUsersRank(int id) {
      userModule.getLeadboardsRank(id).then((users) {
        store.dispatch(LoadUserRankAction(users: users));
      });
    }

    LocalPreferencesService localPreferencesService = LocalPreferencesService();

    DebugUtils.debugPrint("MainScreenViewModel => build: ${DateTime.now()}");
    return MainScreenViewModel(
      sizeScreen: store.state.preferences.sizeScreen,
      currentUser: store.state.users.current,
      users: store.state.users.users,
      isPremium: store.state.purchase.premium,
      soundVolume: store.state.preferences.soundVolume,
      musicVolume: store.state.preferences.musicVolume,
      userChangedEntering: store.state.preferences.userChangedEntering,
      userRemoveAnimations: store.state.preferences.userRemoveAnims,
      userWasChangedEntering: () =>
          store.dispatch(UserChangedWhenEnteringPreferencesAction()),
      changeSoundVolume: () {
        store.dispatch(ChangeSoundVolumenPreferencesAction());
      },
      changeMusicVolume: () {
        store.dispatch(ChangeMusicVolumenPreferencesAction());
      },
      onUserRemoveAnimations: () {
        store.dispatch(SwapRemoveAnimsPreferencesAction());
      },
      onLoadUsers: () {
        dispatchCurrentUser().then((user) {
          dispatchUsersRank(user.id);
        });
        dispatchUsers();
      },
      onAddUser: (name, avatar) {
        userModule.repositoryService
            .addUser(UserRepository(
                id: 0, name: name, coins: 0, avatar: avatar, color: avatar))
            .then((_) {
          dispatchUsers();
        });
      },
      onSelectUser: (id) async {
        store.dispatch(
            BoardSelectedPreferencesAction(board: SizeBoardGame.X3_3));
        store.dispatch(
            ChangeSizeBoardGameAction(sizeBoardGame: SizeBoardGame.X3_3));
        await localPreferencesService.setUserId(id);
        dispatchCurrentUser().then((user) async {
          dispatchUsersRank(user.id);
          List<LevelRepository> levelsRepository = await userModule.getLevels();
          store.dispatch(FillCompletedWorldsAction(
              completed: GameUtils.getWorldsCompleted(
                  levelsRepository, store.state.levels.worlds)));
        });
      },
      onUpdateCurrentUserFirstTime: (name, avatar) async {
        await userModule.repositoryService
            .addCoinsToUser(store.state.users.current.id, 50);
        UserRepository user = await userModule.repositoryService
            .getUserWithId(store.state.users.current.id);
        await userModule.repositoryService.updateUser(
            user.copyWith(name: name, avatar: avatar, color: avatar));
        dispatchCurrentUser();
        dispatchUsers();
      },
      onUpdateUser: (id, name, avatar) async {
        UserRepository user =
            await userModule.repositoryService.getUserWithId(id);
        await userModule.repositoryService.updateUser(
            user.copyWith(name: name, avatar: avatar, color: avatar));
        dispatchCurrentUser();
        dispatchUsers();
      },
      onDeleteUser: (userId) async {
        await userModule.repositoryService.deleteUserWithId(userId);
        dispatchUsers();
      },
      onAddingLevels: () async {
        int userId = await userModule.localPreferencesService.getUserId();
        WorldListEntity worlds = await userModule.entityService.loadWorlds();
        List<LevelRepository> levels = worlds.worlds.expand((world) {
          return List.generate(world.levels, (i) => i + 1).map((l) {
            return LevelRepository(
                number: l, stars: 3, userId: userId, world: world.world);
          });
        }).toList();
        await userModule.repositoryService.deleteAllUserLevels(userId);
        await userModule.repositoryService.addLevels(levels);
      },
      onReloadSizeScreen: (context) {
        if (store.state.preferences.sizeScreen == null) {
          double h = MediaQuery.of(context).size.height;
          store.dispatch(SizeScreenPreferencesAction(
              sizeScreen: SizeUtils.getSizeScreen(h)));
        }
      },
    );
  }
}
