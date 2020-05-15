import 'package:flutter/material.dart';
import 'package:impossiblocks/models/preferences_state.dart';
import 'package:impossiblocks/res/res_colors.dart';

class ResStyles {
  static double _defaultSizeByScreen(SizeScreen sizeScreen, double s) =>
      sizeScreen == SizeScreen.BIG
          ? s + 2
          : sizeScreen == SizeScreen.NORMAL
              ? s
              : sizeScreen == SizeScreen.SMALL ? s - 1 : s - 2;

  static TextStyle titleScreen(SizeScreen sizeScreen) => TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.w900,
      fontSize: _defaultSizeByScreen(sizeScreen, 24.0));

  static TextStyle howToPlayTitleScreen = TextStyle(
      color: Colors.black54, fontWeight: FontWeight.w900, fontSize: 24.0);

  static TextStyle posintInDialog(SizeScreen sizeScreen,
          {color: Colors.black, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 36.0));

  static TextStyle posintInTop(SizeScreen sizeScreen,
          {color: Colors.black, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 34.0));

  static TextStyle bigTitleDialog(SizeScreen sizeScreen,
          {color: Colors.black, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 28.0));

  static TextStyle big(SizeScreen sizeScreen,
          {color: Colors.black, fontWeight: FontWeight.w900, height: 1.0}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 22.0),
          height: height);

  static TextStyle normal(SizeScreen sizeScreen,
          {color: Colors.black, fontWeight: FontWeight.w900, height: 1.0}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 16.0),
          height: height);

  static TextStyle small(SizeScreen sizeScreen,
          {color: Colors.black, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 13.0));

  static TextStyle action(SizeScreen sizeScreen,
          {color: Colors.black, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 18.0));

  static TextStyle tooltip(SizeScreen sizeScreen,
          {color: Colors.black, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 12.0));

  static TextStyle coinsInNavigationBar = TextStyle(
      color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24.0);

  static TextStyle titleMainScreen = TextStyle(
      color: ResColors.primaryColorDark,
      fontWeight: FontWeight.w900,
      fontSize: 18.0);

  static TextStyle subtitleMainScreen = TextStyle(
      color: ResColors.primaryColorDark,
      fontWeight: FontWeight.w900,
      fontSize: 14.0);

  static TextStyle coinsInScreen(SizeScreen sizeScreen) => TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontSize: _defaultSizeByScreen(sizeScreen, 60.0));

  static TextStyle buttonMainScreen = TextStyle(
      color: Colors.white70, fontWeight: FontWeight.w900, fontSize: 22.0);

  static TextStyle startText2Players(SizeScreen sizeScreen,
          {color: Colors.white70, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 18.0));

  static TextStyle countDownText2Players(SizeScreen sizeScreen,
          {color: ResColors.primaryColorDark, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 26.0));

  static TextStyle startText(SizeScreen sizeScreen,
          {color: Colors.white70, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 26.0));

  static TextStyle countDownText(SizeScreen sizeScreen,
          {color: ResColors.primaryColorDark, fontWeight: FontWeight.w900}) =>
      TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: _defaultSizeByScreen(sizeScreen, 32.0));

  static TextStyle clock = TextStyle(
      fontWeight: FontWeight.w700, fontSize: 18.0, color: Colors.white);

  static TextStyle titleArcadeLevelScreen(SizeScreen sizeScreen) => TextStyle(
      color: Colors.white70, fontWeight: FontWeight.w900, fontSize: _defaultSizeByScreen(sizeScreen, 36.0));

  static TextStyle numberArcadeLevelScreen(SizeScreen sizeScreen) => TextStyle(
      color: Colors.white70, fontWeight: FontWeight.w900, fontSize: _defaultSizeByScreen(sizeScreen, 50.0));


  static TextStyle twoPlayersWinOrLost(SizeScreen sizeScreen) => TextStyle(
      color: Colors.white70, fontWeight: FontWeight.w900, fontSize: _defaultSizeByScreen(sizeScreen, 40.0));
}
