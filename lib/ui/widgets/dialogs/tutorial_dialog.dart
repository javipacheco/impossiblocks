import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/board_state.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:impossiblocks/ui/flare/loop_controller.dart';
import 'package:impossiblocks/ui/widgets/dialogs/common_dialog_view_model.dart';
import 'package:impossiblocks/utils/asset_utils.dart';

class TutorialDialog extends StatelessWidget {
  final LoopController _loopController = LoopController('success', 5);

  final int world;

  final int level;

  TutorialDialog({@required this.world, @required this.level});

  static show(BuildContext context, int world, int level) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return;
        },
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: TutorialDialog(
                world: world,
                level: level,
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.roundedLayout),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  bool hasAssistanceActions() {
    return (world == 4 && level == 1) ||
        (world == 4 && level == 2) ||
        (world == 5 && level == 1) ||
        (world == 6 && level == 1);
  }

  Widget getAssistanceActions(SizeScreen sizeScreen) {
    if (world == 4 && level == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AssistanceAction(
            sizeScreen: sizeScreen,
            assistanceActionType: AssistanceActionType.BRUSH1,
            assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
            coins: 15,
            moves: 0,
            onTap: null,
          ),
          SizedBox(width: 16.0),
          AssistanceAction(
            sizeScreen: sizeScreen,
            assistanceActionType: AssistanceActionType.BRUSH2,
            assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
            coins: 15,
            moves: 0,
            onTap: null,
          ),
        ],
      );
    } else if (world == 4 && level == 2) {
      return AssistanceAction(
        sizeScreen: sizeScreen,
        assistanceActionType: AssistanceActionType.BLOCK,
        assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
        coins: 15,
        moves: 0,
        onTap: null,
      );
    } else if (world == 5 && level == 1) {
      return AssistanceAction(
        sizeScreen: sizeScreen,
        assistanceActionType: AssistanceActionType.FIREMAN,
        assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
        coins: 15,
        moves: 0,
        onTap: null,
      );
    } else if (world == 6 && level == 1) {
      return AssistanceAction(
        sizeScreen: sizeScreen,
        assistanceActionType: AssistanceActionType.LIGHTNING,
        assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
        coins: 15,
        moves: 0,
        onTap: null,
      );
    } else {
      return null;
    }
  }

  dialogContent(BuildContext context) {
    String flareFile = "assets/flare/level_${world}_$level.flr";
    return StoreConnector<AppState, CommonDialogViewModel>(
        distinct: true,
        converter: (store) => CommonDialogViewModel.build(store),
        builder: (context, viewModel) {
          double avatarRadiusDialog =
              Dimensions.avatarRadiusDialog(viewModel.sizeScreen);
          double spaceDialog = Dimensions.spaceDialog(viewModel.sizeScreen);
          return Stack(
            children: <Widget>[
              Container(
                constraints: new BoxConstraints(
                  minWidth: 300.0,
                ),
                padding: EdgeInsets.only(
                  top: avatarRadiusDialog + Dimensions.paddingDialog,
                  bottom: Dimensions.paddingDialog,
                  left: Dimensions.paddingDialog,
                  right: Dimensions.paddingDialog,
                ),
                margin: EdgeInsets.only(top: avatarRadiusDialog),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Dimensions.paddingDialog),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${ImpossiblocksLocalizations.of(context).text("level")} $world - $level",
                        style: ResStyles.bigTitleDialog(
                          viewModel.sizeScreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      if (hasAssistanceActions())
                        getAssistanceActions(viewModel.sizeScreen),
                      if (hasAssistanceActions()) SizedBox(height: 16.0),
                      Text(
                        ImpossiblocksLocalizations.of(context)
                            .text("level_msg_${world}_$level"),
                        textAlign: TextAlign.center,
                        style: ResStyles.normal(
                          viewModel.sizeScreen,
                            fontWeight: FontWeight.w700,
                            height: 1.4),
                      ),
                      FutureBuilder(
                        future: AssetUtils.exist(flareFile),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data)
                            return SizedBox(
                              width: 150,
                              height: 150,
                              child: FlareActor(
                                flareFile,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                controller: _loopController,
                              ),
                            );
                          else
                            return SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: spaceDialog),
                      ActionButtonDialog(
                          sizeScreen: viewModel.sizeScreen,
                          text:
                              ImpossiblocksLocalizations.of(context).text("ok"),
                          pressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ),
              ),
              Positioned(
                left: Dimensions.paddingDialog,
                right: Dimensions.paddingDialog,
                child: CircleAvatar(
                  backgroundColor: ResColors.colorTile2,
                  radius: avatarRadiusDialog,
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: avatarRadiusDialog + 14,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
