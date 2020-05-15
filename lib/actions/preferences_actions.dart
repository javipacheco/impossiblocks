import 'package:flutter/material.dart';
import 'package:impossiblocks/models/game_state.dart';
import 'package:impossiblocks/models/preferences_state.dart';

class ChangeSoundVolumenPreferencesAction {
  ChangeSoundVolumenPreferencesAction();

  @override
  String toString() {
    return 'ChangeSoundVolumenPreferencesAction{}';
  }
}

class ChangeMusicVolumenPreferencesAction {
  ChangeMusicVolumenPreferencesAction();

  @override
  String toString() {
    return 'ChangeMusicVolumenPreferencesAction{}';
  }
}

class BoardSelectedPreferencesAction {
  final SizeBoardGame board;

  BoardSelectedPreferencesAction({this.board});

  @override
  String toString() {
    return 'BoardSelectedPreferencesAction{board: $board}';
  }
}

class UserChangedWhenEnteringPreferencesAction {
  UserChangedWhenEnteringPreferencesAction();

  @override
  String toString() {
    return 'UserChangedWhenEnteringPreferencesAction{}';
  }
}

class UserVisitedStorePreferencesAction {
  UserVisitedStorePreferencesAction();

  @override
  String toString() {
    return 'UserVisitedStorePreferencesAction{}';
  }
}

class SwapRemoveAnimsPreferencesAction {

  SwapRemoveAnimsPreferencesAction();

  @override
  String toString() {
    return 'SwapRemoveAnimsPreferencesAction{}';
  }
}

class SelectLangPreferencesAction {

  String lang;

  SelectLangPreferencesAction({@required this.lang});

  @override
  String toString() {
    return 'SelectLangPreferencesAction{lang: $lang}';
  }
}

class SizeScreenPreferencesAction {

  SizeScreen sizeScreen;

  SizeScreenPreferencesAction({@required this.sizeScreen});

  @override
  String toString() {
    return 'SizeScreenPreferencesAction{sizeScreen: $sizeScreen}';
  }
}
