import 'package:equatable/equatable.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';

class PreferencesScreenViewModel extends Equatable {
  final bool userRemoveAnimations;

  final SizeScreen sizeScreen;

  final Function() onChangeAnimation;

  PreferencesScreenViewModel({
    @required this.userRemoveAnimations,
    @required this.sizeScreen,
    @required this.onChangeAnimation,
  }) : super([userRemoveAnimations, sizeScreen]);

  static build(Store<AppState> store) {
    return PreferencesScreenViewModel(
        userRemoveAnimations: store.state.preferences.userRemoveAnims,
        sizeScreen: store.state.preferences.sizeScreen,
        onChangeAnimation: () {
          store.dispatch(SwapRemoveAnimsPreferencesAction());
        });
  }
}
