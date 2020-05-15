import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/coins/viewmodels/coins_container_view_model.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:impossiblocks/ui/widgets/dialogs/fortune_wheel_dialog.dart';
import 'package:impossiblocks/ui/widgets/rounded_container.dart';

class CoinsContainer extends StatefulWidget {
  CoinsContainer({Key key}) : super(key: key);

  _CoinsContainerState createState() => _CoinsContainerState();
}

class _CoinsContainerState extends State<CoinsContainer> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CoinsContainerViewModel>(
        distinct: true,
        converter: (store) => CoinsContainerViewModel.build(store),
        builder: (context, viewModel) {
          return RoundedContainer(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  RoundedContainer(
                    color: ResColors.colorTile1,
                    child: Column(
                      children: <Widget>[
                        Text(
                          ImpossiblocksLocalizations.of(context)
                              .text("have_to_play"),
                          style: ResStyles.big(viewModel.sizeScreen,
                              color: Colors.white70),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            viewModel.currentUser.coins.toString(),
                            style:
                                ResStyles.coinsInScreen(viewModel.sizeScreen),
                          ),
                        ),
                        Text(
                            ImpossiblocksLocalizations.of(context)
                                .text("coins")
                                .toLowerCase(),
                            style: ResStyles.big(viewModel.sizeScreen,
                                color: Colors.white70)),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 24),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Dimensions.coinsHeightContainer(
                            viewModel.sizeScreen)),
                    child: RoundedContainer(
                      color: Colors.white,
                      bgColor: ResColors.colorTile1,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 32.0),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                ImpossiblocksLocalizations.of(context)
                                    .text("get_money_now"),
                                textAlign: TextAlign.center,
                                style: ResStyles.normal(viewModel.sizeScreen,
                                    color: Colors.black87),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ActionButtonDialog(
                                  sizeScreen: viewModel.sizeScreen,
                                  text: ImpossiblocksLocalizations.of(context)
                                      .text("wheel_fortune"),
                                  bgColor: ResColors.primaryColor,
                                  pressed: () {
                                    FortuneWheelDialog.show(
                                          context, viewModel.soundVolume,
                                          (coins) {
                                        viewModel.onAddCoins(coins);
                                      });
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                ImpossiblocksLocalizations.of(context)
                                    .text("coins_arcade_msg"),
                                textAlign: TextAlign.center,
                                style: ResStyles.normal(viewModel.sizeScreen,
                                    color: Colors.black87),
                              ),
                            ),
                            buildAssistanceItem(
                                viewModel.sizeScreen,
                                AssistanceActionType.BRUSH1,
                                ImpossiblocksLocalizations.of(context)
                                    .replaceText("coins_count", "0", "15"),
                                ImpossiblocksLocalizations.of(context)
                                    .text("brush1_desc")),
                            SizedBox(height: 16.0),
                            buildAssistanceItem(
                                viewModel.sizeScreen,
                                AssistanceActionType.BRUSH2,
                                ImpossiblocksLocalizations.of(context)
                                    .replaceText("coins_count", "0", "15"),
                                ImpossiblocksLocalizations.of(context)
                                    .text("brush2_desc")),
                            SizedBox(height: 16.0),
                            buildAssistanceItem(
                                viewModel.sizeScreen,
                                AssistanceActionType.FIREMAN,
                                ImpossiblocksLocalizations.of(context)
                                    .replaceText("coins_count", "0", "5"),
                                ImpossiblocksLocalizations.of(context)
                                    .text("fireman_desc")),
                            SizedBox(height: 16.0),
                            buildAssistanceItem(
                                viewModel.sizeScreen,
                                AssistanceActionType.LIGHTNING,
                                ImpossiblocksLocalizations.of(context)
                                    .replaceText("coins_count", "0", "5"),
                                ImpossiblocksLocalizations.of(context)
                                    .text("ray_desc")),
                            SizedBox(height: 16.0),
                            buildAssistanceItem(
                                viewModel.sizeScreen,
                                AssistanceActionType.BLOCK,
                                ImpossiblocksLocalizations.of(context)
                                    .text("block_coins"),
                                ImpossiblocksLocalizations.of(context)
                                    .text("block_desc")),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  Padding buildAssistanceItem(SizeScreen sizeScreen,
      AssistanceActionType assistance, String title, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AssistanceAction(
              sizeScreen: sizeScreen,
              assistanceActionType: assistance,
              assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
              coins: 100,
              moves: 10,
              onTap: (_) {},
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: ResStyles.big(sizeScreen, color: Colors.black87),
                ),
                Text(
                  text,
                  style: ResStyles.normal(sizeScreen, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
