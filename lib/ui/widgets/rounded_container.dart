import 'package:flutter/material.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_dimensions.dart';

class RoundedContainer extends StatefulWidget {
  final Widget child;

  final Color bgColor;

  final Color color;

  final EdgeInsets padding;

  RoundedContainer({Key key, @required this.child,  @required this.color, this.bgColor = ResColors.primaryColor, this.padding = EdgeInsets.zero}) : super(key: key);

  _RoundedContainerState createState() => _RoundedContainerState();
}

class _RoundedContainerState extends State<RoundedContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.bgColor,
      child: Material(
        clipBehavior: Clip.antiAlias,
        color: widget.color,
        shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
            topLeft: new Radius.circular(Dimensions.roundedLayout),
            topRight: new Radius.circular(Dimensions.roundedLayout))),
        child: Container(
      constraints: BoxConstraints.expand(),
      alignment: Alignment.topCenter,
      child: Padding(
        padding: widget.padding,
        child: widget.child,
      ),
        ),
      ),
    );
  }
}
