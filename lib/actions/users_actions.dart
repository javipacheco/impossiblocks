import 'package:impossiblocks/models/models.dart';
import 'package:flutter/foundation.dart';

class LoadCurrentUserAction {

  final UserState user;

  LoadCurrentUserAction({@required this.user});

  @override
  String toString() {
    return 'LoadCurrentUserAction{user: $user}';
  }
}

class LoadUsersAction {

  final List<UserState> users;

  LoadUsersAction({@required this.users});

  @override
  String toString() {
    return 'LoadCurrentUserAction{users: $users}';
  }
}

class LoadUserRankAction {

  final List<UserRankState> users;

  LoadUserRankAction({@required this.users});

  @override
  String toString() {
    return 'LoadUserRankAction{users: $users}';
  }
}