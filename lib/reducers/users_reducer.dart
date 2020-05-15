import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final usersStateReducer = combineReducers<UsersState>([
  TypedReducer<UsersState, LoadCurrentUserAction>(_loadCurrentUser),
  TypedReducer<UsersState, LoadUsersAction>(_loadUsers),
  TypedReducer<UsersState, LoadUserRankAction>(_loadUsersRank),
]);

UsersState _loadCurrentUser(
    UsersState users, LoadCurrentUserAction action) {
  return users.copyWith(current: action.user);
}

UsersState _loadUsers(
    UsersState users, LoadUsersAction action) {
  return users.copyWith(users: action.users);
}

UsersState _loadUsersRank(
    UsersState users, LoadUserRankAction action) {
  return users.copyWith(userRank: action.users);
}