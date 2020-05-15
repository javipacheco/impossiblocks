import 'package:flutter/material.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'dart:math';

class SizeUtils {
  static double getBoardSize(BuildContext context, SizeScreen sizeScreen,
      int columns, bool hasAssitanceBar, bool hasClock) {
    Size size = MediaQuery.of(context).size;

    double heightContainer = size.height -
        Dimensions.toolbarHeight -
        Dimensions.infoHeightContainer(sizeScreen) -
        (hasAssitanceBar
            ? Dimensions.paddingTopBoardWithBarAssistance +
                Dimensions.magicBarkHeight(sizeScreen)
            : Dimensions.paddingTopBoard) -
        (hasClock ? Dimensions.clockHeight(context, sizeScreen) : 0);

    double screen = (size.width < size.height) ? size.width : size.height;
    return min((screen < heightContainer ? screen : heightContainer) * 0.9,
        columns == 3 ? 400 : columns == 4 ? 500 : 600);
  }

  static double getTileSize(BuildContext context, SizeScreen sizeScreen,
      int columns, bool hasAssitanceBar, bool hasClock) {
    return (getBoardSize(
                context, sizeScreen, columns, hasAssitanceBar, hasClock) /
            columns) -
        (Dimensions.paddingTile * columns);
  }

  static double getTileSizeForTwoPlayers(
      BuildContext context, SizeScreen sizeScreen, int columns) {
    Size size = MediaQuery.of(context).size;

    double middleHeight = Dimensions.startButtonHeight(sizeScreen);

    double widthContainer = size.width - middleHeight;
    double heightContainer = size.height / 2;

    double screen = (widthContainer < heightContainer) ? widthContainer : heightContainer;

    double boardSize = min(
        screen * 0.85,
        columns == 3 ? 400 : columns == 4 ? 500 : 600);

    return (boardSize / columns) - (Dimensions.paddingTile * columns);
  }

  static SizeScreen getSizeScreen(double h) => h > 900
      ? SizeScreen.BIG
      : h > 650
          ? SizeScreen.NORMAL
          : h > 550 ? SizeScreen.SMALL : SizeScreen.NANO;
}
