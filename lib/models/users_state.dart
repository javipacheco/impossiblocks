import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:impossiblocks/res/res_colors.dart';
import "package:equatable/equatable.dart";
import 'package:impossiblocks/models/models.dart';

@immutable
class UserRankState extends Equatable {
  final LeadboardGames leadboardGame;

  final int rank;

  UserRankState({this.leadboardGame, this.rank}) : super([leadboardGame, rank]);

  @override
  String toString() {
    return 'UserRankState{leadboardGame: $leadboardGame, rank: $rank}';
  }
}

@immutable
class UsersState extends Equatable {
  final UserState current;

  final List<UserState> users;

  final List<UserRankState> userRank;

  UsersState({this.current, this.users, this.userRank})
      : super([current, users, userRank]);

  UsersState copyWith({
    UserState current,
    List<UserState> users,
    List<UserRankState> userRank,
  }) {
    return UsersState(
      current: current ?? this.current,
      users: users ?? this.users,
      userRank: userRank ?? this.userRank,
    );
  }

  int getRank(LeadboardGames leadboardGame) {
    return userRank
            .firstWhere((r) => r.leadboardGame == leadboardGame,
                orElse: () => null)
            ?.rank ??
        0;
  }

  @override
  String toString() {
    return 'UsersState{current: $current, users: $users, userRank: $userRank}';
  }
}

@immutable
class UserState extends Equatable {
  final int id;

  final int color;

  final int avatar;

  final String name;

  final int coins;

  final int record;

  final int rank;

  UserState(
      {this.id,
      this.color,
      this.avatar,
      this.name,
      this.coins,
      this.record,
      this.rank})
      : super([id, color, avatar, name, coins, record, rank]);

  UserState copyWith({
    int id,
    int color,
    int avatar,
    String name,
    int coins,
    int record,
    int rank,
  }) {
    return UserState(
      id: id ?? this.id,
      color: color ?? this.color,
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      coins: coins ?? this.coins,
      record: record ?? this.record,
      rank: rank ?? this.rank,
    );
  }

  Color getColor() {
    return ResColors.getAvatarColor(color ?? 0);
  }

  factory UserState.fromRepository(UserRepository user) {
    return UserState(
        id: user.id,
        color: user.color,
        avatar: user.avatar,
        name: user.name,
        coins: user.coins,
        record: 0,
        rank: 0);
  }

  @override
  String toString() {
    return 'UserState{id: $id, color: $color, avatar: $avatar, name: $name, coins: $coins, record: $record, rank: $rank}';
  }
}

@immutable
class UsersPlayGameState extends Equatable {
  final ViewStatus viewStatus;

  final List<UserState> users;

  final GooglePlayAccount googlePlayAccount;

  UsersPlayGameState({this.viewStatus, this.users, this.googlePlayAccount})
      : super([viewStatus, users, googlePlayAccount]);

  UsersPlayGameState copyWith(
      {ViewStatus viewStatus,
      List<UserState> users,
      GooglePlayAccount googlePlayAccount}) {
    return UsersPlayGameState(
      viewStatus: viewStatus ?? this.viewStatus,
      users: users ?? this.users,
      googlePlayAccount: googlePlayAccount ?? this.googlePlayAccount,
    );
  }

  @override
  String toString() {
    return 'UsersPlayGameState{viewStatus: $viewStatus, users: $users, googlePlayAccount: $googlePlayAccount}';
  }
}

@immutable
class GooglePlayAccount extends Equatable {
  final String id;
  final String displayName;
  final String email;

  GooglePlayAccount({this.id, this.displayName, this.email})
      : super([id, displayName, email]);

  // factory GooglePlayAccount.fromAccount(Account account) {
  //   return GooglePlayAccount(
  //     id: account.id,
  //     displayName: account.displayName,
  //     email: account.email,
  //   );
  // }
}