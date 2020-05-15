import 'package:flutter/material.dart';
import 'package:impossiblocks/models/preferences_state.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';
import 'dart:math';

class Dimensions {
  static double getHeightContainer(SizeScreen sizeScreen, double s) =>
      sizeScreen == SizeScreen.BIG
          ? s + 10
          : sizeScreen == SizeScreen.NORMAL
              ? s
              : sizeScreen == SizeScreen.SMALL ? s - 10 : s - 20;

  static double getSizeIcon(SizeScreen sizeScreen, double s) =>
      sizeScreen == SizeScreen.BIG
          ? s + 5
          : sizeScreen == SizeScreen.NORMAL
              ? s
              : sizeScreen == SizeScreen.SMALL ? s - 5 : s - 10;

  static double getSizePadding(SizeScreen sizeScreen, double s) =>
      sizeScreen == SizeScreen.BIG
          ? s + 2
          : sizeScreen == SizeScreen.NORMAL
              ? s
              : sizeScreen == SizeScreen.SMALL ? s - 2 : s - 4;

  static double paddingTile = 6.0;

  static double roundedLayout = 35.0;

  static double infoHeightContainer(SizeScreen sizeScreen) =>
      sizeScreen == SizeScreen.BIG
          ? 120
          : sizeScreen == SizeScreen.NORMAL
              ? 100
              : sizeScreen == SizeScreen.SMALL ? 92 : 85;

  static double paddingTopBoard = 10.0;

  static double paddingTopBoardWithBarAssistance = 15.0;

  static double toolbarHeight = 56.0;

  static double startButtonHeight(SizeScreen sizeScreen) =>
      getSizeIcon(sizeScreen, 56.0);

  static double clockHeight(BuildContext context, SizeScreen sizeScreen) {
    return startButtonHeight(sizeScreen) + boardPaddingBottom(context);
  }

  static double boardPaddingBottom(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return 16.0 + (height > 700 ? min(80, height - 700) : 0);
  }

  static double magicBarkHeight(SizeScreen sizeScreen) =>
      AssistanceCommons.siseAction(sizeScreen) + (4 * 2);

  static double worldsHeightContainer(SizeScreen sizeScreen) =>
      getHeightContainer(sizeScreen, 160.0);

  static double leadboardsHeightContainer = 80.0;

  static double coinsHeightContainer(SizeScreen sizeScreen) =>
      getHeightContainer(sizeScreen, 160.0);

  static double roundedBoard(int columns) {
    return 60.0 / columns;
  }

  static const double paddingDialog = 16.0;

  static double spaceDialog(SizeScreen sizeScreen) =>
      sizeScreen == SizeScreen.BIG
          ? 32
          : sizeScreen == SizeScreen.NORMAL
              ? 24
              : sizeScreen == SizeScreen.SMALL ? 20 : 16;

  static double avatarRadiusDialog(SizeScreen sizeScreen) =>
      sizeScreen == SizeScreen.BIG
          ? 76
          : sizeScreen == SizeScreen.NORMAL
              ? 66
              : sizeScreen == SizeScreen.SMALL ? 56 : 46;

  static double getWidthStartButton(SizeScreen sizeScreen, double s) =>
      sizeScreen == SizeScreen.BIG
          ? s + 20
          : sizeScreen == SizeScreen.NORMAL
              ? s
              : sizeScreen == SizeScreen.SMALL ? s - 20 : s - 40;
}
