import 'package:equatable/equatable.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';

class CommonDialogViewModel extends Equatable {
  final SizeScreen sizeScreen;

  CommonDialogViewModel({
    @required this.sizeScreen,
  }) : super([sizeScreen]);

  static build(Store<AppState> store) {
    DebugUtils.debugPrint("CommonDialogViewModel => build: ${DateTime.now()}");
    return CommonDialogViewModel(
      sizeScreen: store.state.preferences.sizeScreen,
    );
  }
}
