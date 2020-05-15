import 'package:flutter/material.dart';
import 'package:impossiblocks/models/models.dart';

class AddPointToScoreAction {

  final PlayersGame playersGame;

  AddPointToScoreAction({@required this.playersGame});

  @override
  String toString() {
    return 'AddPointToScoreAction{playersGame: $playersGame}';
  }
}

class RemovePointToScoreAction {

  final PlayersGame playersGame;

  RemovePointToScoreAction({@required this.playersGame});

  @override
  String toString() {
    return 'RemovePointToScoreAction{playersGame: $playersGame}';
  }
}

class AddTimeToScoreAction {
  
  final int time;

  AddTimeToScoreAction({this.time = 2});

  @override
  String toString() {
    return 'AddTimeToScoreAction{time: $time}';
  }
}

/*
Actualiza los puntos del modo Arcade con los segundos que han sobrado
*/
class UpdateScoreForUpgradingLevelAction {
  
  UpdateScoreForUpgradingLevelAction();

  @override
  String toString() {
    return 'UpdateScoreForUpgradingLevelAction{}';
  }
}

class ReduceTimeToScoreAction {

  ReduceTimeToScoreAction();

  @override
  String toString() {
    return 'ReduceTimeToScoreAction{}';
  }
}

class ResetScoreAction {

  ResetScoreAction();

  @override
  String toString() {
    return 'ResetScoreAction{}';
  }
}

class PauseAction {

  PauseAction();

  @override
  String toString() {
    return 'PauseAction{}';
  }
}

class ResumeAction {

  ResumeAction();

  @override
  String toString() {
    return 'ResumeAction{}';
  }
}