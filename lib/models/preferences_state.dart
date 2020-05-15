import 'package:flutter/foundation.dart';
import "package:equatable/equatable.dart";
import 'package:impossiblocks/models/models.dart';

enum SizeScreen { BIG, NORMAL, SMALL, NANO }

@immutable
class PreferencesState extends Equatable {
  final int soundVolume;

  final int musicVolume;

  final SizeBoardGame boardSelected;

  final bool userChangedEntering;

  final bool userVisitedStore;

  final bool userRemoveAnims;

  final String locale;

  final SizeScreen sizeScreen;

  PreferencesState({
    this.soundVolume,
    this.musicVolume,
    this.boardSelected,
    this.userChangedEntering,
    this.userVisitedStore,
    this.userRemoveAnims,
    this.locale,
    this.sizeScreen,
  }) : super([
          soundVolume,
          musicVolume,
          boardSelected,
          userChangedEntering,
          userVisitedStore,
          userRemoveAnims,
          locale,
          sizeScreen,
        ]);

  factory PreferencesState.init() {
    return PreferencesState(
        soundVolume: 2,
        musicVolume: 2,
        boardSelected: SizeBoardGame.X3_3,
        userChangedEntering: false,
        userVisitedStore: false,
        userRemoveAnims: false,
        locale: null, 
        sizeScreen: null);
  }

  PreferencesState copyWith(
      {soundVolume,
      musicVolume,
      boardSelected,
      userChangedEntering,
      userVisitedStore,
      userRemoveAnims,
      locale,
      sizeScreen,}) {
    return PreferencesState(
      soundVolume: soundVolume ?? this.soundVolume,
      musicVolume: musicVolume ?? this.musicVolume,
      boardSelected: boardSelected ?? this.boardSelected,
      userChangedEntering: userChangedEntering ?? this.userChangedEntering,
      userVisitedStore: userVisitedStore ?? this.userVisitedStore,
      userRemoveAnims: userRemoveAnims ?? this.userRemoveAnims,
      locale: locale ?? this.locale,
      sizeScreen: sizeScreen ?? this.sizeScreen,
    );
  }

  @override
  String toString() {
    return 'PreferencesState{volume: $soundVolume, musicVolume: $musicVolume, boardSelected: $boardSelected, userChangedEntering: $userChangedEntering, userVisitedStore: $userVisitedStore, userRemoveAnims: $userRemoveAnims, locale: $locale, sizeScreen: $sizeScreen}';
  }
}
