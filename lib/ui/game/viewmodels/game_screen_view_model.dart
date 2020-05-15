import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:flutter/widgets.dart';
import "package:equatable/equatable.dart";

class GameScreenViewModel extends Equatable {
  final BoardStatus boardStatus;

  final LevelListState levels;

  final GameStatus gameViewStatus;

  final Function onPause;

  final Function onResume;

  GameScreenViewModel({
    @required this.boardStatus,
    @required this.levels,
    @required this.gameViewStatus,
    @required this.onPause,
    @required this.onResume,
  }) : super([boardStatus, levels, gameViewStatus]);

  static build(Store<AppState> store) {
    DebugUtils.debugPrint("GameScreenViewModel => build: ${DateTime.now()}");
    return GameScreenViewModel(
        boardStatus: store.state.board,
        gameViewStatus: store.state.gameViewStatus.status,
        levels: store.state.levels,
        onPause: () {
          SoundController.instance.stopMusic();
          store.dispatch(PauseAction());
        },
        onResume: () {
          SoundController.instance
              .playMusic(store.state.preferences.musicVolume, 1.0);
          store.dispatch(ResumeAction());
        });
  }
}
