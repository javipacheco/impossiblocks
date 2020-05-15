import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/game/viewmodels/game_container_view_model.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:impossiblocks/ui/widgets/fireworks.dart';
import 'package:share/share.dart';

class GameSuccessDialog extends StatelessWidget {
  final GameContainerViewModel viewModel;

  final bool newRecord;

  GameSuccessDialog({
    @required this.viewModel,
    @required this.newRecord,
  });

  static show(BuildContext context, GameContainerViewModel viewModel) {
    viewModel.onUpdateRecordGame().then((newRecord) {
      SoundController.instance.play(
          newRecord
              ? SoundEffect.LONG_CELEBRATION
              : SoundEffect.SHORT_CELEBRATION,
          viewModel.soundVolume,
          1.0);
      showGeneralDialog(
              context: context,
              pageBuilder: (context, anim1, anim2) {
                return;
              },
              barrierDismissible: true,
              barrierColor: Colors.black.withOpacity(0.4),
              barrierLabel: '',
              transitionBuilder: (context, a1, a2, widget) {
                final curvedValue =
                    Curves.easeInOutBack.transform(a1.value) - 1.0;
                return Transform(
                  transform:
                      Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                  child: Opacity(
                    opacity: a1.value,
                    child: GameSuccessDialog(
                        viewModel: viewModel, newRecord: newRecord),
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 300))
          .then((v) {
        // Si fue llamado onNextLevel desde una acción, v tiene true
        if (v == null) viewModel.onReloadGame(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.roundedLayout),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(context),
        ),
        Positioned.fill(
            child: IgnorePointer(
                child: newRecord ? Fireworks(50, 2) : Fireworks(30, 0))),
      ],
    );
  }

  dialogContent(BuildContext context) {
    Color color = ResColors.getAvatarColor(viewModel.currentUser.color);
    double avatarRadiusDialog =
        Dimensions.avatarRadiusDialog(viewModel.sizeScreen);
    double spaceDialog = Dimensions.spaceDialog(viewModel.sizeScreen);
    return Stack(
      children: <Widget>[
        Container(
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
          child: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    ImpossiblocksLocalizations.of(context)
                        .text(newRecord ? "new_record" : "congrats"),
                    style: ResStyles.bigTitleDialog(
                      viewModel.sizeScreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    viewModel.points.toString(),
                    style: ResStyles.posintInDialog(
                      viewModel.sizeScreen,
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ImpossiblocksLocalizations.of(context)
                        .text("points")
                        .toLowerCase(),
                    style: ResStyles.normal(
                      viewModel.sizeScreen,
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: spaceDialog + 8),
                  Text(
                    ImpossiblocksLocalizations.of(context).replaceText(
                        "game_coins_msg",
                        "0",
                        viewModel.currentUser.coins.toString()),
                    textAlign: TextAlign.center,
                    style: ResStyles.normal(
                      viewModel.sizeScreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: spaceDialog),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ActionButtonDialog(
                          sizeScreen: viewModel.sizeScreen,
                          text: ImpossiblocksLocalizations.of(context)
                              .text("share"),
                          pressed: () {
                            String typeBoardGame =
                                viewModel.boardStatus.typeBoard ==
                                        TypeBoardGame.ARCADE
                                    ? ImpossiblocksLocalizations.of(context)
                                        .text("arcade")
                                    : viewModel.boardStatus.typeBoard ==
                                            TypeBoardGame.CLASSIC
                                        ? ImpossiblocksLocalizations.of(context)
                                            .text("classic")
                                        : ImpossiblocksLocalizations.of(context)
                                            .text("level");
                            String sizeBoardGame =
                                viewModel.gameViewStatus.sizeBoardGame ==
                                        SizeBoardGame.X3_3
                                    ? "3x3"
                                    : viewModel.gameViewStatus.sizeBoardGame ==
                                            SizeBoardGame.X4_4
                                        ? "4x4"
                                        : "5x5";
                            Share.share(ImpossiblocksLocalizations.of(context)
                                .replaceTextMap("share_points_msg", {
                              "00": viewModel.points.toString(),
                              "01": "$sizeBoardGame $typeBoardGame"
                            }));
                            viewModel.onReloadGame(false);
                            Navigator.pop(context, true);
                          }),
                      ActionButtonDialog(
                          sizeScreen: viewModel.sizeScreen,
                          text: ImpossiblocksLocalizations.of(context)
                              .text("play_again"),
                          pressed: () {
                            viewModel.onReloadGame(true);
                            Navigator.pop(context, true);
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: Dimensions.paddingDialog,
          right: Dimensions.paddingDialog,
          child: CircleAvatar(
            backgroundColor: color,
            radius: avatarRadiusDialog,
            child: SvgPicture.asset(
              "assets/images/face_${viewModel.currentUser.avatar}.svg",
              color: Colors.white,
              width: avatarRadiusDialog + 14,
              height: avatarRadiusDialog + 14,
            ),
          ),
        ),
      ],
    );
  }
}
