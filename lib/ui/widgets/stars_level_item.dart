import 'package:flutter/material.dart';

class StartsLevelItem extends StatelessWidget {
  final int stars;

  final Color color;

  final double size;

  const StartsLevelItem({
    Key key,
    @required this.stars,
    @required this.color,
    @required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildStarIcon(stars >= 1),
        buildStarIcon(stars >= 2),
        buildStarIcon(stars >= 3),
      ],
    );
  }

  Widget buildStarIcon(bool fill) {
    return Expanded(
      child: Icon(
        fill ? Icons.star : Icons.star_border,
        color: color,
        size: size,
      ),
    );
  }
}
