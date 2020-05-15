import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/utils/game_utils.dart';

enum GameStatus { WAITING, COUNTDOWN, PLAYING, CHANGING_LEVEL, RESUME, IDLE }

enum SizeBoardGame { X3_3, X4_4, X5_5 }

@immutable
class GameViewStatus extends Equatable {
  final SizeBoardGame sizeBoardGame;

  final GameStatus status;

  GameViewStatus(
      {this.sizeBoardGame = SizeBoardGame.X3_3,
      this.status = GameStatus.WAITING})
      : super([sizeBoardGame, status]);

  GameViewStatus copyWith({
    SizeBoardGame sizeBoardGame,
    GameStatus status,
  }) {
    return GameViewStatus(
      sizeBoardGame: sizeBoardGame ?? this.sizeBoardGame,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'GameViewStatus{sizeBoardGame: $sizeBoardGame, status: $status}';
  }
}

@immutable
class Score extends Equatable {
  final int points;

  final int pointsPlayerTwo;

  final int seconds;

  final int prevSeconds;

  final int prevPointsForSeconds;

  final bool pause;

  Score({
    this.points = 0,
    this.pointsPlayerTwo = 0,
    this.seconds = GameUtils.maxTime,
    this.prevSeconds = 0,
    this.prevPointsForSeconds = 0,
    this.pause = false,
  }) : super([points, seconds]);

  Score copyWith({
    int points,
    int pointsPlayerTwo,
    int seconds,
    int prevSeconds,
    int prevPointsForSeconds,
    bool pause,
  }) {
    return Score(
      points: points ?? this.points,
      pointsPlayerTwo: pointsPlayerTwo ?? this.pointsPlayerTwo,
      seconds: seconds ?? this.seconds,
      prevSeconds: prevSeconds ?? this.prevSeconds,
      prevPointsForSeconds: prevPointsForSeconds ?? this.prevPointsForSeconds,
      pause: pause ?? this.pause,
    );
  }

  factory Score.reset() {
    return Score(points: 0, pointsPlayerTwo: 0, seconds: GameUtils.maxTime);
  }

  Score addPoint(PlayersGame playersGame) {
    return playersGame == PlayersGame.ONE
        ? copyWith(points: this.points + 1)
        : copyWith(pointsPlayerTwo: this.pointsPlayerTwo + 1);
  }

  Score removePoint(PlayersGame playersGame) {
    return playersGame == PlayersGame.ONE
        ? copyWith(points: this.points > 0 ? this.points - 1 : this.points)
        : copyWith(pointsPlayerTwo: this.pointsPlayerTwo > 0 ? this.pointsPlayerTwo - 1 : this.pointsPlayerTwo);
  }

  Score addTime({int time}) {
    if (pause) {
      return this;
    } else {
      var sum = this.seconds + time;
      return copyWith(
          seconds: sum > GameUtils.maxTime ? GameUtils.maxTime : sum);
    }
  }

  Score updateScoreForUpgradingLevel() {
    int prevPointsForSeconds = seconds ~/ 10;
    return copyWith(
        prevSeconds: seconds,
        prevPointsForSeconds: prevPointsForSeconds,
        points: this.points + prevPointsForSeconds,
        seconds: GameUtils.maxTime);
  }

  Score reduceTime() {
    return pause
        ? this
        : copyWith(seconds: this.seconds > 0 ? this.seconds - 1 : this.seconds);
  }

  bool isTimeFinished() {
    return seconds <= 0;
  }

  @override
  String toString() {
    return 'Score{points: $points, pointsPlayerTwo: $pointsPlayerTwo, seconds: $seconds, prevSeconds: $prevSeconds, prevPointsForSeconds: $prevPointsForSeconds, pause: $pause}';
  }
}

@immutable
class ScoreCounterColorsLevel extends Equatable {
  final int color1;

  final int color2;

  final int level;

  ScoreCounterColorsLevel({
    this.color1 = 0,
    this.color2 = 0,
    this.level = 0,
  }) : super([color1, color2, level]);

  ScoreCounterColorsLevel copyWith({
    int color1,
    int color2,
    int level,
  }) {
    return ScoreCounterColorsLevel(
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      level: level ?? this.level,
    );
  }

  ScoreCounterColorsLevel resetLevel(int level) {
    return copyWith(level: level, color1: level, color2: level);
  }

  ScoreCounterColorsLevel failedLevel() {
    return copyWith(color1: color1 + 1);
  }

  ScoreCounterColorsLevel upgradeLevel() {
    var nextLevel = level + 1;
    return copyWith(level: nextLevel, color1: nextLevel, color2: nextLevel);
  }

  ScoreCounterColorsLevel succesColor(int color) {
    return color == 0 ? succesColor1() : succesColor2();
  }

  ScoreCounterColorsLevel succesColor1() {
    return color1 > 0 ? copyWith(color1: this.color1 - 1) : this;
  }

  ScoreCounterColorsLevel succesColor2() {
    return color2 > 0 ? copyWith(color2: this.color2 - 1) : this;
  }

  bool isWin() {
    return color1 <= 0 && color2 <= 0;
  }

  @override
  String toString() {
    return 'ScoreCounterColorsLevel{color1: $color1, color2: $color2}';
  }
}
