import 'package:flutter/material.dart';

class StartsDialog extends StatelessWidget {
  final int stars;

  final Color color;

  final double size;

  final EdgeInsets padding;

  const StartsDialog(
      {Key key,
      @required this.stars,
      @required this.color,
      @required this.size,
      @required this.padding})
      : super(key: key);

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
    return Padding(
      padding: padding,
      child: Icon(
        fill ? Icons.star : Icons.star_border,
        color: color,
        size: size,
      ),
    );
  }
}
