import 'package:impossiblocks/models/models.dart';

class ChangeStatusGameAction {

  final GameStatus status;

  ChangeStatusGameAction({this.status});

  @override
  String toString() {
    return 'ChangeStatusGameAction{status: $status}';
  }
}

class ChangeSizeBoardGameAction {

  final SizeBoardGame sizeBoardGame;

  ChangeSizeBoardGameAction({this.sizeBoardGame});

  @override
  String toString() {
    return 'ChangeSizeBoardGameAction{status: $sizeBoardGame}';
  }
}