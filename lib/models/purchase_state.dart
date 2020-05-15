import 'package:flutter/foundation.dart';
import "package:equatable/equatable.dart";

@immutable
class PurchaseState extends Equatable {

  final bool premium;

  PurchaseState(
      {this.premium})
      : super([premium]);

  factory PurchaseState.init() {
    return PurchaseState(
        premium: false);
  }

  PurchaseState copyWith({premium}) {
    return PurchaseState(
      premium: premium ?? this.premium,
    );
  }

  @override
  String toString() {
    return 'PurchaseState{premium: $premium}';
  }
}
