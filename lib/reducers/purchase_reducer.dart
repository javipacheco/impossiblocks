import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final purchaseStateReducer = combineReducers<PurchaseState>([
  TypedReducer<PurchaseState, PremiumPurchasedAction>(
      _premiumPurchased),
]);

PurchaseState _premiumPurchased(
    PurchaseState purchase, PremiumPurchasedAction action) {
  return purchase.copyWith(premium: true);
}

