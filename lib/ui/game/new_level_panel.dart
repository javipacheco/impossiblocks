import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/app_state.dart';
import 'package:impossiblocks/models/preferences_state.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/game/board_translate.dart';
import 'package:impossiblocks/ui/game/viewmodels/new_level_panel_view_model.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:impossiblocks/ui/widgets/dialogs/fortune_wheel_dialog.dart';
import 'package:impossiblocks/utils/game_utils.dart';
import 'package:impossiblocks/utils/size_utils.dart';

class NewLevelPanel extends StatefulWidget {
  NewLevelPanel({Key key}) : super(key: key);
  _NewLevelPanelState createState() => _NewLevelPanelState();
}

class _NewLevelPanelState extends State<NewLevelPanel> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewLevelPanelViewBoard>(
        distinct: true,
        converter: (store) => NewLevelPanelViewBoard.build(store),
        builder: (context, viewModel) {
          double separated =
              Dimensions.getHeightContainer(viewModel.sizeScreen, 24.0);
          double boardSize = SizeUtils.getBoardSize(
              context, viewModel.sizeScreen, viewModel.columms, true, true);
          return BoardTranslate(
            child: Container(
              width: boardSize,
              height: boardSize,
              decoration: new BoxDecoration(
                  color: ResColors.primaryColor,
                  borderRadius: new BorderRadius.all(
                      Radius.circular(Dimensions.roundedBoard(3)))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (viewModel.sizeScreen == SizeScreen.NANO ||
                      viewModel.sizeScreen == SizeScreen.SMALL)
                    Text(
                      "${ImpossiblocksLocalizations.of(context).text("level")} ${viewModel.scoreCounterColorsLevel.level}",
                      style: ResStyles.titleArcadeLevelScreen(
                          viewModel.sizeScreen),
                    ),
                  if (viewModel.sizeScreen == SizeScreen.NORMAL ||
                      viewModel.sizeScreen == SizeScreen.BIG)
                    Text(
                      ImpossiblocksLocalizations.of(context).text("level"),
                      style: ResStyles.titleArcadeLevelScreen(
                          viewModel.sizeScreen),
                    ),
                  if (viewModel.sizeScreen == SizeScreen.NORMAL ||
                      viewModel.sizeScreen == SizeScreen.BIG)
                    Text(
                      "${viewModel.scoreCounterColorsLevel.level}",
                      style: ResStyles.numberArcadeLevelScreen(
                          viewModel.sizeScreen),
                    ),
                  SizedBox(height: separated),
                  Text(
                    ImpossiblocksLocalizations.of(context).replaceText(
                        "time_left",
                        "00:00",
                        GameUtils.getTimeFormatted(
                            viewModel.score.prevSeconds)),
                    style: ResStyles.normal(viewModel.sizeScreen,
                        color: Colors.white60),
                  ),
                  Text(
                    "+${viewModel.score.prevPointsForSeconds} ${ImpossiblocksLocalizations.of(context).text("points").toLowerCase()}",
                    style: ResStyles.big(viewModel.sizeScreen,
                        color: Colors.white),
                  ),
                  SizedBox(height: separated),
                  Text(
                    ImpossiblocksLocalizations.of(context).replaceText(
                        "coins_to_play_on",
                        "0",
                        "${viewModel.currentUser.coins}"),
                    style: ResStyles.normal(viewModel.sizeScreen,
                        color: Colors.white),
                  ),
                  SizedBox(height: separated),
                  ActionButtonDialog(
                      sizeScreen: viewModel.sizeScreen,
                      text: ImpossiblocksLocalizations.of(context)
                          .text("wheel_fortune"),
                      bgColor: Colors.black26,
                      pressed: () {
                        FortuneWheelDialog.show(
                              context, viewModel.soundVolume, (coins) {
                            viewModel.onAddCoins(coins);
                          });
                      }),
                  ActionButtonDialog(
                      sizeScreen: viewModel.sizeScreen,
                      text: ImpossiblocksLocalizations.of(context)
                          .text("continue"),
                      pressed: () {
                        viewModel.onPlayGame();
                      })
                ],
              ),
            ),
          );
        });
  }
}
