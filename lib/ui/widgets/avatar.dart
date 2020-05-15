import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impossiblocks/res/res_colors.dart';

class Avatar extends StatelessWidget {
  final int color;

  final int avatar;

  const Avatar({Key key, @required this.color, @required this.avatar,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: ResColors.getAvatarColor(color ?? 0),
          borderRadius: BorderRadius.circular(6.0)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: IconAvatar(avatar: avatar),
      ),
    );
  }
}

class IconAvatar extends StatelessWidget {
  final int avatar;

  const IconAvatar({@required this.avatar, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return avatar != null
        ? SvgPicture.asset(
            "assets/images/face_${avatar ?? 0}.svg",
            color: Colors.white,
            width: 32,
            height: 32,
          )
        : SizedBox.shrink();
  }
}
