import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Medal {
  final int world;
  final bool achieved;

  Medal({this.world, this.achieved});
}

class Medals extends StatelessWidget {
  final List<Medal> items;

  final Color selectedColor;

  final Color normalColor;
  Medals(
      {Key key,
      @required this.items,
      @required this.selectedColor,
      @required this.normalColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: new Border.all(color: Colors.grey.withAlpha(50)),
            borderRadius: BorderRadius.circular(30.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var item in items)
              MedalIcon(
                world: item.world,
                color: item.achieved ? selectedColor : normalColor,
              )
          ],
        ));
  }
}

class MedalIcon extends StatelessWidget {
  final int world;

  final Color color;

  const MedalIcon({
    Key key,
    @required this.world,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: SvgPicture.asset(
        "assets/images/ic_medal_$world.svg",
        color: color,
        width: 30,
        height: 30,
      ),
    );
  }
}
