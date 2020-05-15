import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/widgets/avatar.dart';

class UserLeadboardItem extends StatelessWidget {
  final SizeScreen sizeScreen;

  final List<UserState> users;

  final GooglePlayAccount account;

  const UserLeadboardItem(
      {Key key, @required this.sizeScreen, @required this.users, this.account})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: false,
      itemCount: users.length,
      itemBuilder: (context, i) {
        var user = users[i];
        int rank = user.rank > 0 ? user.rank : i + 1;
        bool userHighlight =
            account != null && account.displayName == user.name;
        return Container(
          color: userHighlight ? Colors.yellow.withAlpha(120) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: Avatar(avatar: user?.avatar, color: user?.color),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user.name,
                          style: ResStyles.normal(sizeScreen),
                        ),
                        Text(
                          "${user.record} ${ImpossiblocksLocalizations.of(context).text("points").toLowerCase()}",
                          style: ResStyles.normal(sizeScreen,
                              fontWeight: userHighlight
                                  ? FontWeight.w900
                                  : FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Text(
                    "${ImpossiblocksLocalizations.of(context).text("rank")} $rank",
                    style: ResStyles.normal(sizeScreen,
                        fontWeight:
                            userHighlight ? FontWeight.w900 : FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      rank > 3
                          ? "assets/images/ic_medal.svg"
                          : "assets/images/ic_crown.svg",
                      color: rank == 1
                          ? Colors.yellow
                          : rank == 2
                              ? Colors.grey
                              : rank == 3 ? Colors.orange : Colors.grey[300],
                      width: 18,
                      height: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
