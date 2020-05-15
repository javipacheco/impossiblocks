import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final usersPlayGamesStateReducer = combineReducers<UsersPlayGameState>([
  TypedReducer<UsersPlayGameState, LoadPlayGameUsersAction>(_loadPlayGamesUsers),
  TypedReducer<UsersPlayGameState, WaitingPlayGameUsersAction>(_showLoadingPlayGamesUsers),
  TypedReducer<UsersPlayGameState, SuccessPlayGameUsersAction>(_successPlayGamesUsers),
  TypedReducer<UsersPlayGameState, ErrorsPlayGameUsersAction>(_errorPlayGamesUsers),
  TypedReducer<UsersPlayGameState, EmptyPlayGameUsersAction>(_emptyPlayGamesUsers),
  TypedReducer<UsersPlayGameState, GooglePlayAccountAction>(_googlePlayAccount),
]);

UsersPlayGameState _loadPlayGamesUsers(
    UsersPlayGameState users, LoadPlayGameUsersAction action) {
  return users.copyWith(users: action.users);
}

UsersPlayGameState _showLoadingPlayGamesUsers(
    UsersPlayGameState users, WaitingPlayGameUsersAction action) {
  return users.copyWith(viewStatus: ViewStatus.WAITING);
}

UsersPlayGameState _successPlayGamesUsers(
    UsersPlayGameState users, SuccessPlayGameUsersAction action) {
  return users.copyWith(viewStatus: ViewStatus.SUCCESS);
}

UsersPlayGameState _errorPlayGamesUsers(
    UsersPlayGameState users, ErrorsPlayGameUsersAction action) {
  return users.copyWith(viewStatus: ViewStatus.ERROR);
}

UsersPlayGameState _emptyPlayGamesUsers(
    UsersPlayGameState users, EmptyPlayGameUsersAction action) {
  return users.copyWith(viewStatus: ViewStatus.EMPTY);
}

UsersPlayGameState _googlePlayAccount(
    UsersPlayGameState users, GooglePlayAccountAction action) {
  return users.copyWith(googlePlayAccount: action.account);
}
