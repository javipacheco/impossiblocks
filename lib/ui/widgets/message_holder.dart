import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impossiblocks/models/preferences_state.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/widgets/dialogs/action_button_dialog.dart';

class MessageHolder extends StatelessWidget {
  final SizeScreen sizeScreen;

  final String message;

  final String icon;

  final String msgButton;

  final Function onClickButton;

  const MessageHolder(
      {Key key,
      @required this.sizeScreen,
      @required this.message,
      this.icon,
      this.msgButton,
      this.onClickButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null)
          Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: SvgPicture.asset(
                "assets/images/$icon.svg",
                color: Colors.black38,
                width: 94,
                height: 94,
              )),
        Text(message, style: ResStyles.normal(sizeScreen)),
        if (msgButton != null)
          ActionButtonDialog(
            sizeScreen: sizeScreen,
            text: msgButton,
            pressed: onClickButton,
          )
      ],
    );
  }
}
