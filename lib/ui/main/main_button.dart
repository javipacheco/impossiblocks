import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impossiblocks/models/preferences_state.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';

class MainButton extends StatelessWidget {
  final SizeScreen sizeScreen;

  final String title;

  final String asset;

  final Function onTap;

  const MainButton({
    Key key,
    @required this.sizeScreen,
    @required this.title,
    @required this.asset,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: RaisedButton(
        color: ResColors.primaryColorDark,
        colorBrightness: Brightness.dark,
        onPressed: onTap,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: Container(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SvgPicture.asset("assets/images/$asset.svg",
                      color: Colors.white70, width: 20, height: 20,),
                ),
                Flexible(
                    child: Text(title,
                        overflow: TextOverflow.ellipsis,
                        style: ResStyles.big(sizeScreen, color: Colors.white70, fontWeight: FontWeight.w900))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
