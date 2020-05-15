import 'package:flutter/widgets.dart';

class ImpossiblocksKeys {
  // Home Screens
  static final homeScreen = const Key('__homeScreen__');

  // level list
  static final levelList = const Key('__levelList__');
  static final levelListLoading = const Key('__levelListLoading__');

  static final levelItem = (String id) => Key('Level__$id');

}