import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_colors.dart';

import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/widgets/bar_progress_background.dart';
import 'dart:math';

import 'package:impossiblocks/ui/widgets/text_fade.dart';

class WorldCardsView extends StatefulWidget {
  final SizeScreen sizeScreen;

  final LevelListState levelList;

  final int world;

  final Function onPrevWorld;

  final Function onNextWorld;

  WorldCardsView({
    @required this.levelList,
    @required this.sizeScreen,
    @required this.world,
    @required this.onPrevWorld,
    @required this.onNextWorld,
  });

  @override
  _WorldCardsViewState createState() => _WorldCardsViewState();
}

class _WorldCardsViewState extends State<WorldCardsView> {
  @override
  Widget build(BuildContext context) {
    var worldItem = widget.levelList.worlds
        .firstWhere((w) => w.world == widget.world, orElse: () => null);
    return SizedBox(
        height: Dimensions.getHeightContainer(widget.sizeScreen, 130),
        child: Row(
          children: <Widget>[
            buildButton(
                Icons.arrow_back_ios,
                Dimensions.getSizeIcon(widget.sizeScreen, 48),
                widget.onPrevWorld),
            if (worldItem != null)
              Expanded(
                child: WorldCard(
                  sizeScreen: widget.sizeScreen,
                  world: worldItem,
                  worldCompleted:
                      widget.levelList.getWorldsCompleted(worldItem.world),
                ),
              ),
            buildButton(
                Icons.arrow_forward_ios,
                Dimensions.getSizeIcon(widget.sizeScreen, 48),
                widget.onNextWorld),
          ],
        ));
  }

  SizedBox buildButton(IconData icon, double size, Function onPressed) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        color: Colors.red,
        onPressed: onPressed,
        icon: Icon(icon, color: ResColors.primaryColor.withAlpha(200)),
      ),
    );
  }
}

class WorldCard extends StatelessWidget {
  final SizeScreen sizeScreen;

  final WorldsState world;

  final WorldsCompletedState worldCompleted;

  const WorldCard({
    Key key,
    @required this.sizeScreen,
    @required this.world,
    @required this.worldCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int percentage =
        worldCompleted != null && worldCompleted.levelsCompleted != null
            ? (worldCompleted.levelsCompleted * 100) ~/ world.levels
            : 0;
    return Container(
      margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
      decoration: new BoxDecoration(
          color: ResColors.boardBackground,
          borderRadius:
              new BorderRadius.all(Radius.circular(Dimensions.roundedLayout))),
      child: Column(
        children: <Widget>[
          Container(
              height: Dimensions.getSizeIcon(sizeScreen, 50),
              width: double.infinity,
              decoration: new BoxDecoration(
                  color: ResColors.primaryColor,
                  borderRadius: new BorderRadius.all(
                      Radius.circular(Dimensions.roundedLayout))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextFade(
                    message:
                        ImpossiblocksLocalizations.of(context).text(world.name),
                    style: ResStyles.big(sizeScreen, color: Colors.white70),
                  ),
                ),
              )),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width > 600 ? (width - 600) / 2 : 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/images/ic_medal_${world.world}.svg",
                  color: worldCompleted?.completed != null &&
                          worldCompleted.completed
                      ? Colors.green
                      : Colors.grey.withAlpha(160),
                  width: Dimensions.getSizeIcon(sizeScreen, 48),
                  height: Dimensions.getSizeIcon(sizeScreen, 48),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BarProgressBackground(
                        height: 10,
                        colorBack: Colors.grey.withAlpha(160),
                        colorFront: Colors.green,
                        percentage: min(100, percentage),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          worldCompleted != null && worldCompleted.completed
                              ? ImpossiblocksLocalizations.of(context)
                                  .text("all_levels_completed")
                              : ImpossiblocksLocalizations.of(context)
                                  .replaceText(
                                      "count_levels_completed",
                                      "0",
                                      (worldCompleted?.levelsCompleted ?? 0)
                                          .toString()),
                          style: ResStyles.normal(sizeScreen, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
