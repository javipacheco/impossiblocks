import 'package:flutter/material.dart';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/ui/game/viewmodels/game_container_view_model.dart';
import 'package:impossiblocks/ui/two_players/two_players_container.dart';
import 'package:impossiblocks/ui/two_players/viewmodels/two_players_screen_view_model.dart';

class TwoPlayersScreen extends StatefulWidget {
  TwoPlayersScreen({Key key}) : super(key: key);

  @override
  _TwoPlayersScreenState createState() => _TwoPlayersScreenState();
}

class _TwoPlayersScreenState extends State<TwoPlayersScreen> {

  GameContainerPrevViewModel _gameContainerPrevViewModel =
      GameContainerPrevViewModel();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TwoPlayersScreenViewModel>(
        distinct: true,
        converter: (store) => TwoPlayersScreenViewModel.build(store),
        onInitialBuild: (viewModel) {
          _gameContainerPrevViewModel.reload(viewModel.gameViewStatus);
        },
        onDispose: (store) {
          SoundController.instance.stopMusic();
        },
        onWillChange: (viewModel) {
          _gameContainerPrevViewModel.reload(viewModel.gameViewStatus);
        },
        builder: (context, viewModel) {
          return Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
            child: Scaffold(
              body: TwoPlayersContainer(),
            ),
          );
        });
  }
}
