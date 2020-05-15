import 'package:flutter/material.dart';
import 'package:impossiblocks/models/preferences_state.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/utils/size_utils.dart';

class TitleAppBar extends StatelessWidget {
  final String title;

  const TitleAppBar({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeScreen sizeScreen =
        SizeUtils.getSizeScreen(MediaQuery.of(context).size.height);
    return title != null
        ? Text(title, style: ResStyles.titleScreen(sizeScreen))
        : Image.asset(
            'assets/logo_big.png',
            height: sizeScreen == SizeScreen.BIG
                ? 28
                : sizeScreen == SizeScreen.NORMAL
                    ? 24
                    : sizeScreen == SizeScreen.SMALL ? 22 : 20,
          );
  }
}
