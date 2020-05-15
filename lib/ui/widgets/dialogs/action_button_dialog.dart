import 'package:flutter/material.dart';
import 'package:impossiblocks/models/preferences_state.dart';
import 'package:impossiblocks/res/res_styles.dart';

class ActionButtonDialog extends StatelessWidget {
  final SizeScreen sizeScreen;

  final String text;

  final Function pressed;

  final Color bgColor;

  const ActionButtonDialog(
      {Key key,
      @required this.sizeScreen,
      @required this.text,
      @required this.pressed,
      this.bgColor: Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: RaisedButton(
          elevation: 6,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new Text(text,
              style: ResStyles.action(sizeScreen,
                  color: Colors.white70, fontWeight: FontWeight.w700)),
          color: bgColor,
          colorBrightness: Brightness.dark,
          onPressed: () => pressed(),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0))),
    );
  }
}
