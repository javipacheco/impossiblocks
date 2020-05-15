import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/modules/modules.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/game/viewmodels/game_container_view_model.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';
import 'package:impossiblocks/ui/widgets/fireworks.dart';
import 'package:impossiblocks/ui/widgets/stars_dialog.dart';

class LevelSuccessDialog extends StatelessWidget {
  static final String _celebrationAudio = "celebration";

  LevelSuccessDialog();

  static show(BuildContext context, Function onReloadLevel) {
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
                  child: LevelSuccessDialog(),
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 300))
        .then((v) {
      SoundController.instance.getAudio(_celebrationAudio)?.stop();
      SoundController.instance.remove(_celebrationAudio);
      // Si fue llamado onNextLevel desde una acción, v tiene true
      if (v == null) onReloadLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameContainerViewModel>(
        converter: (store) => GameContainerViewModel.build(store, UserModule()),
        distinct: true,
        onInitialBuild: (viewModel) {
          int stars = viewModel.levelListState.getStarsForCurrentLevel();
          SoundController.instance.play(
              stars == 3
                  ? SoundEffect.LONG_CELEBRATION
                  : stars == 2
                      ? SoundEffect.MIDDLE_CELEBRATION
                      : SoundEffect.SHORT_CELEBRATION,
              viewModel.soundVolume,
              1.0,
              name: _celebrationAudio);
        },
        builder: (context, viewModel) {
          int stars = viewModel.levelListState.getStarsForCurrentLevel();
          return Stack(
            children: <Widget>[
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.roundedLayout),
                ),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: dialogContent(context, viewModel, stars),
              ),
              Positioned.fill(
                  child: IgnorePointer(
                      child: stars == 3
                          ? Fireworks(50, 2)
                          : stars == 2 ? Fireworks(30, 1) : Fireworks(30, 0))),
            ],
          );
        });
  }

  dialogContent(
      BuildContext context, GameContainerViewModel viewModel, int stars) {
    Color color = ResColors.getAvatarColor(viewModel.currentUser.color);
    double avatarRadiusDialog =
        Dimensions.avatarRadiusDialog(viewModel.sizeScreen);
    double spaceDialog = Dimensions.spaceDialog(viewModel.sizeScreen);
    double sizeStars = viewModel.sizeScreen == SizeScreen.BIG
        ? 48
        : viewModel.sizeScreen == SizeScreen.NORMAL
            ? 44
            : viewModel.sizeScreen == SizeScreen.SMALL ? 40 : 36;
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
                    ImpossiblocksLocalizations.of(context).text(
                        viewModel.levelListState.isLastLevel()
                            ? "level_completed"
                            : "congrats"),
                    style: ResStyles.bigTitleDialog(
                      viewModel.sizeScreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    ImpossiblocksLocalizations.of(context)
                        .replaceText("give_coins", "0", "2"),
                    textAlign: TextAlign.center,
                    style: ResStyles.normal(viewModel.sizeScreen,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "${viewModel.currentUser.coins} ${ImpossiblocksLocalizations.of(context).text("coins").toLowerCase()}",
                    textAlign: TextAlign.center,
                    style: ResStyles.big(viewModel.sizeScreen,
                        color: color, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: spaceDialog),
                    child: StartsDialog(
                        stars: stars,
                        color: ResColors.colorTile1,
                        size: sizeStars,
                        padding: const EdgeInsets.all(8.0)),
                  ),
                  Text(
                      stars > 0
                          ? ImpossiblocksLocalizations.of(context)
                              .randomText("star_${stars}_msg", 3)
                          : "",
                      textAlign: TextAlign.center,
                      style: ResStyles.normal(viewModel.sizeScreen,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: spaceDialog),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (stars < 3)
                        ActionButtonDialog(
                            sizeScreen: viewModel.sizeScreen,
                            text: ImpossiblocksLocalizations.of(context)
                                .text("play_again"),
                            pressed: () {
                              viewModel.onReloadLevel();
                              Navigator.pop(context, true);
                            }),
                      viewModel.levelListState.isLastLevel()
                          ? ActionButtonDialog(
                              sizeScreen: viewModel.sizeScreen,
                              text: ImpossiblocksLocalizations.of(context)
                                  .text("finish"),
                              pressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              bgColor: ResColors.colorTile1)
                          : ActionButtonDialog(
                              sizeScreen: viewModel.sizeScreen,
                              text: ImpossiblocksLocalizations.of(context)
                                  .text("next"),
                              pressed: () {
                                Timer(Duration(milliseconds: 600), () {
                                  viewModel.onNextLevel();
                                });
                                Navigator.pop(context, true);
                              },
                              bgColor: ResColors.primaryColor),
                    ],
                  ),
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
              viewModel.levelListState.isLastLevel()
                  ? "assets/images/ic_medal_${viewModel.levelListState.currentWorld}.svg"
                  : "assets/images/face_${viewModel.currentUser.avatar}.svg",
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
