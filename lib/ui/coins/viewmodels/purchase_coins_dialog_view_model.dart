import 'package:equatable/equatable.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';

class PurchaseCoinsDialogViewModel extends Equatable {
  final SizeScreen sizeScreen;

  PurchaseCoinsDialogViewModel({
    @required this.sizeScreen,
  }) : super([sizeScreen]);

  static build(Store<AppState> store) {

    DebugUtils.debugPrint(
        "PurchaseCoinsDialogViewModel => build: ${DateTime.now()}");
    return PurchaseCoinsDialogViewModel(
      sizeScreen: store.state.preferences.sizeScreen,
    );
  }
}
