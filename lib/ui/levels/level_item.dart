import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:impossiblocks/ui/widgets/stars_level_item.dart';

class LevelItem extends StatelessWidget {
  final bool isPlayable;
  final GestureTapCallback onTap;
  final LevelState level;
  final SizeScreen sizeScreen;

  LevelItem(
      {@required this.isPlayable,
      @required this.onTap,
      @required this.level,
      @required this.sizeScreen});

  @override
  Widget build(BuildContext context) {
    double sizeHeader = sizeScreen == SizeScreen.BIG
        ? 40
        : sizeScreen == SizeScreen.NORMAL
            ? 34
            : sizeScreen == SizeScreen.SMALL ? 28 : 24;
    double sizeStars = sizeScreen == SizeScreen.BIG
        ? 28
        : sizeScreen == SizeScreen.NORMAL
            ? 24
            : sizeScreen == SizeScreen.SMALL ? 20 : 16;
    double padding = sizeScreen == SizeScreen.BIG
        ? 16
        : sizeScreen == SizeScreen.NORMAL
            ? 12
            : sizeScreen == SizeScreen.SMALL ? 10 : 8;
    return Padding(
        padding: EdgeInsets.all(padding),
        child: RaisedButton(
          color: level.done ? ResColors.colorTile1 : Colors.grey,
          colorBrightness: Brightness.dark,
          onPressed: () {
            if (isPlayable) onTap();
          },
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: isPlayable
                      ? Text("${level.number}",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: sizeHeader))
                      : Icon(
                          Icons.lock,
                          color: Colors.white70,
                          size: sizeHeader,
                        ),
                ),
                StartsLevelItem(
                  stars: level.stars,
                  color: level.done ? Colors.white : Colors.white30,
                  size: sizeStars
                )
              ],
            ),
          ),
        ));
  }
}
