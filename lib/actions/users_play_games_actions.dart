import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';

class LoadPlayGameUsersAction {

  final List<UserState> users;

  LoadPlayGameUsersAction({@required this.users});

  @override
  String toString() {
    return 'LoadPlayGameUsersAction{users: $users}';
  }
}

class WaitingPlayGameUsersAction {

  WaitingPlayGameUsersAction();

  @override
  String toString() {
    return 'WaitingPlayGameUsersAction{}';
  }
}

class SuccessPlayGameUsersAction {

  SuccessPlayGameUsersAction();

  @override
  String toString() {
    return 'SuccessPlayGameUsersAction{}';
  }
}

class EmptyPlayGameUsersAction {

  EmptyPlayGameUsersAction();

  @override
  String toString() {
    return 'EmptyPlayGameUsersAction{}';
  }
}

class ErrorsPlayGameUsersAction {

  ErrorsPlayGameUsersAction();

  @override
  String toString() {
    return 'ErrorsPlayGameUsersAction{}';
  }
}

class GooglePlayAccountAction {

  GooglePlayAccount account;

  GooglePlayAccountAction({this.account});

  @override
  String toString() {
    return 'GooglePlayAccountAction{account: $account}';
  }
}
