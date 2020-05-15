import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final preferentesStateReducer = combineReducers<PreferencesState>([
  TypedReducer<PreferencesState, ChangeSoundVolumenPreferencesAction>(
      _soundVolume),
  TypedReducer<PreferencesState, ChangeMusicVolumenPreferencesAction>(
      _musicVolume),
  TypedReducer<PreferencesState, BoardSelectedPreferencesAction>(
      _boardSelected),
  TypedReducer<PreferencesState, UserChangedWhenEnteringPreferencesAction>(
      _userChangeWhenEntering),
  TypedReducer<PreferencesState, UserVisitedStorePreferencesAction>(
      _userVisitedStore),
  TypedReducer<PreferencesState, SwapRemoveAnimsPreferencesAction>(
      _userRemoveAnims),
  TypedReducer<PreferencesState, UserVisitedStorePreferencesAction>(
      _userVisitedStore),
  TypedReducer<PreferencesState, SelectLangPreferencesAction>(_selectLang),
  TypedReducer<PreferencesState, SizeScreenPreferencesAction>(_sizeScreen),
]);

PreferencesState _soundVolume(
    PreferencesState preferences, ChangeSoundVolumenPreferencesAction action) {
  return preferences.copyWith(
      soundVolume:
          preferences.soundVolume >= 2 ? 0 : preferences.soundVolume + 1);
}

PreferencesState _musicVolume(
    PreferencesState preferences, ChangeMusicVolumenPreferencesAction action) {
  return preferences.copyWith(
      musicVolume:
          preferences.musicVolume >= 2 ? 0 : preferences.musicVolume + 1);
}

PreferencesState _boardSelected(
    PreferencesState preferences, BoardSelectedPreferencesAction action) {
  return preferences.copyWith(boardSelected: action.board);
}

PreferencesState _userChangeWhenEntering(PreferencesState preferences,
    UserChangedWhenEnteringPreferencesAction action) {
  return preferences.copyWith(userChangedEntering: true);
}

PreferencesState _userVisitedStore(
    PreferencesState preferences, UserVisitedStorePreferencesAction action) {
  return preferences.copyWith(userVisitedStore: true);
}

PreferencesState _userRemoveAnims(
    PreferencesState preferences, SwapRemoveAnimsPreferencesAction action) {
  return preferences.copyWith(userRemoveAnims: !preferences.userRemoveAnims);
}

PreferencesState _selectLang(
    PreferencesState preferences, SelectLangPreferencesAction action) {
  return preferences.copyWith(locale: action.lang);
}

PreferencesState _sizeScreen(
    PreferencesState preferences, SizeScreenPreferencesAction action) {
  return preferences.copyWith(sizeScreen: action.sizeScreen);
}
