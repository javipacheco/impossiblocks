import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/models/preferences_state.dart';
import 'package:impossiblocks/models/purchase_state.dart';
import 'package:meta/meta.dart';
import "package:equatable/equatable.dart";

enum ViewStatus { WAITING, SUCCESS, ERROR, EMPTY }

enum Position {
  UP,
  DOWN,
  LEFT,
  RIGHT,
  UP_RIGHT,
  UP_LEFT,
  DOWN_RIGHT,
  DOWN_LEFT
}

@immutable
class AppState extends Equatable {
  final PreferencesState preferences;

  final PurchaseState purchase;

  final UsersState users;

  final UsersPlayGameState usersPlayGames;

  final Score score;

  final ScoreCounterColorsLevel scoreCounterColorsLevel;

  final BoardStatus board;

  final BoardStatus boardPlayerTwo;

  final GameViewStatus gameViewStatus;

  final LevelListState levels;

  AppState({
    this.preferences,
    this.purchase,
    this.users,
    this.usersPlayGames,
    this.score,
    this.scoreCounterColorsLevel,
    this.board,
    this.boardPlayerTwo,
    this.gameViewStatus,
    this.levels,
  }) : super([
          preferences,
          purchase,
          users,
          usersPlayGames,
          score,
          scoreCounterColorsLevel,
          board,
          boardPlayerTwo,
          gameViewStatus,
          levels
        ]);

  factory AppState.init() {
    return AppState(
        preferences: PreferencesState.init(),
        purchase: PurchaseState.init(),
        users: UsersState(current: null, users: List(), userRank: List()),
        usersPlayGames:
            UsersPlayGameState(viewStatus: ViewStatus.SUCCESS, users: List()),
        score: Score(),
        scoreCounterColorsLevel: ScoreCounterColorsLevel(),
        board: BoardStatus.empty(),
        boardPlayerTwo: BoardStatus.empty(),
        gameViewStatus: GameViewStatus(),
        levels: LevelListState.empty());
  }

  @override
  String toString() {
    return 'AppState{preferences: $preferences, purchase: $purchase, users: $users, usersPlayGames: $usersPlayGames, scoreCounterColorsLevel: $scoreCounterColorsLevel, score: $score, board: $board, boardPlayerTwo: $boardPlayerTwo, gameViewStatus: $gameViewStatus, levels: $levels}';
  }

  static AppState fromJson(dynamic json) {
    return json == null
        ? null
        : AppState(
            preferences: PreferencesState(
              soundVolume: json["soundVolume"] ?? 2,
              musicVolume: json["musicVolume"] ?? 2,
              boardSelected: json["sizeBoardGame"] != null
                  ? SizeBoardGame.values
                      .firstWhere((e) => e.toString() == json["sizeBoardGame"])
                  : SizeBoardGame.X3_3,
              userChangedEntering: json["userChangedEntering"] ?? false,
              userVisitedStore: json["userVisitedStore"] ?? false,
              userRemoveAnims: json["userRemoveAnims"] ?? false,
              locale: json["locale"],
              sizeScreen: json["sizeScreen"] != null
                  ? json["sizeScreen"] == SizeScreen.BIG.toString()
                      ? SizeScreen.BIG
                      : json["sizeScreen"] == SizeScreen.NANO.toString()
                          ? SizeScreen.NANO
                          : json["sizeScreen"] == SizeScreen.SMALL.toString()
                              ? SizeScreen.SMALL
                              : SizeScreen.NORMAL
                  : null,
            ),
            purchase: PurchaseState(premium: json["premium"] ?? false),
            users: UsersState(current: null, users: List(), userRank: List()),
            usersPlayGames: UsersPlayGameState(
                viewStatus: ViewStatus.SUCCESS, users: List()),
            score: Score(),
            scoreCounterColorsLevel: ScoreCounterColorsLevel(),
            board: BoardStatus.empty(),
            boardPlayerTwo: BoardStatus.empty(),
            gameViewStatus: GameViewStatus(),
            levels: LevelListState.empty());
  }

  Map toJson() => {
        'soundVolume': preferences.soundVolume,
        'musicVolume': preferences.musicVolume,
        'sizeBoardGame': preferences.boardSelected.toString(),
        'userChangedEntering': preferences.userChangedEntering,
        'userVisitedStore': preferences.userVisitedStore,
        'userRemoveAnims': preferences.userRemoveAnims,
        'locale': preferences.locale,
        'sizeScreen': preferences.sizeScreen.toString(),
        'premium': purchase.premium,
      };
}

@immutable
class Movement extends Equatable {
  final BoardStatus board;
  final int column;
  final int row;

  Movement({@required this.board, @required this.column, @required this.row})
      : super([board, column, row]);

  factory Movement.byPosition(BoardStatus board, int position) {
    return Movement(
        board: board,
        row: position ~/ board.columns,
        column: position % board.columns);
  }

  Movement copyWith({
    BoardStatus board,
    int column,
    int row,
  }) {
    return Movement(
        board: board ?? this.board,
        column: column ?? this.column,
        row: row ?? this.row);
  }

  int getPosition() {
    return (row * board.columns) + column;
  }

  Movement getMovement(Position position) {
    Movement movement;
    if (position == Position.UP) {
      movement = copyWith(row: row - 1);
    } else if (position == Position.DOWN) {
      movement = copyWith(row: row + 1);
    } else if (position == Position.LEFT) {
      movement = copyWith(column: column - 1);
    } else if (position == Position.RIGHT) {
      movement = copyWith(column: column + 1);
    } else if (position == Position.UP_LEFT) {
      movement = copyWith(row: row - 1, column: column - 1);
    } else if (position == Position.UP_RIGHT) {
      movement = copyWith(row: row - 1, column: column + 1);
    } else if (position == Position.DOWN_LEFT) {
      movement = copyWith(row: row + 1, column: column - 1);
    } else if (position == Position.DOWN_RIGHT) {
      movement = copyWith(row: row + 1, column: column + 1);
    }

    return (movement.row < 0 ||
            movement.row > board.rows - 1 ||
            movement.column < 0 ||
            movement.column > board.columns - 1)
        ? null
        : movement;
  }

  List<Movement> getMovementInVertical() {
    return List.generate(board.rows, (i) => i)
        .map((r) => copyWith(row: r))
        .toList();
  }

  List<Movement> getMovementInHorizontal() {
    return List.generate(board.columns, (i) => i)
        .map((c) => copyWith(column: c))
        .toList();
  }

  @override
  String toString() {
    return 'Movement{board: $board, column: $column, row: $row}';
  }
}
