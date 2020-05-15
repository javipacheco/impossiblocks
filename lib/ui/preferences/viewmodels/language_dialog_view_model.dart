import 'package:equatable/equatable.dart';
import 'package:impossiblocks/actions/preferences_actions.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';

class LanguageDialogViewModel extends Equatable {

  final String locale;

  final SizeScreen sizeScreen;

  final Function(String) onSelectLang;

  LanguageDialogViewModel({
    @required this.locale,
    @required this.sizeScreen,
    @required this.onSelectLang,
  }) : super([locale]);

  static build(Store<AppState> store) {

    DebugUtils.debugPrint("LanguageDialogViewModel => build: ${DateTime.now()}");
    return LanguageDialogViewModel(
      locale: store.state.preferences.locale,
      sizeScreen: store.state.preferences.sizeScreen,
      onSelectLang: (lang) {
        store.dispatch(SelectLangPreferencesAction(lang: lang));
      }
    );
  }
}
