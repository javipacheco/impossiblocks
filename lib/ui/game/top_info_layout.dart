import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_styles.dart';

class TopInfoClassicLayout extends StatelessWidget {
  final SizeScreen sizeScreen;

  final int record;

  final int points;

  final int moves;

  TopInfoClassicLayout({
    Key key,
    @required this.sizeScreen,
    @required this.record,
    @required this.points,
    @required this.moves,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TopInfoWithRecord(
                sizeScreen: sizeScreen,
                name: ImpossiblocksLocalizations.of(context).text("points"),
                data: points,
                record: record),
          ]),
    );
  }
}

class TopInfoArcadeLayout extends StatelessWidget {
  final SizeScreen sizeScreen;

  final int record;

  final int points;

  final ScoreCounterColorsLevel scoreCounterColorsLevel;

  TopInfoArcadeLayout({
    Key key,
    @required this.sizeScreen,
    @required this.record,
    @required this.points,
    @required this.scoreCounterColorsLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TileCounterInfo(
                sizeScreen: sizeScreen,
                bgColor: ResColors.colorTile1,
                counter: scoreCounterColorsLevel.color1),
            TopInfoWithRecord(
              sizeScreen: sizeScreen,
              name: ImpossiblocksLocalizations.of(context).text("points"),
              data: points,
              record: record,
            ),
            TileCounterInfo(
                sizeScreen: sizeScreen,
                bgColor: ResColors.colorTile2,
                counter: scoreCounterColorsLevel.color2),
          ]),
    );
  }
}

class TopInfoLevelLayout extends StatelessWidget {
  final SizeScreen sizeScreen;

  final BoardStatus boardStatus;

  final ScoreCounterColorsLevel scoreCounterColorsLevel;

  TopInfoLevelLayout(
      {Key key,
      @required this.sizeScreen,
      @required this.boardStatus,
      @required this.scoreCounterColorsLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (boardStatus.typeLevel == TypeBoardLevel.COLOR_COUNTER)
              TileCounterInfo(
                  sizeScreen: sizeScreen,
                  bgColor: ResColors.colorTile1,
                  counter: scoreCounterColorsLevel.color1),
            TopInfo(
              sizeScreen: sizeScreen,
                name: ImpossiblocksLocalizations.of(context).text("moves"),
                data: boardStatus.typeLevel == TypeBoardLevel.COLOR_COUNTER
                    ? boardStatus.allMoves
                    : boardStatus.moves,
                highlight: true),
            if (boardStatus.typeLevel == TypeBoardLevel.COLOR_COUNTER)
              TileCounterInfo(
                  sizeScreen: sizeScreen,
                  bgColor: ResColors.colorTile2,
                  counter: scoreCounterColorsLevel.color2),
          ]),
    );
  }
}

class TopInfoWithRecord extends StatelessWidget {
  final SizeScreen sizeScreen;

  final String name;

  final int data;

  final int record;

  const TopInfoWithRecord({
    Key key,
    @required this.sizeScreen,
    @required this.name,
    @required this.data,
    @required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int r = data > record ? data : record;
    return SizedBox(
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TopInfo(
              sizeScreen: sizeScreen,
              name: name,
              data: data,
              highlight: true,
              color: data > record ? ResColors.colorTile2 : null,
              removePadding: true,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              constraints: BoxConstraints.expand(width: 80, height: 20),
              decoration: new BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: ResColors.colorTile2,
                  borderRadius: new BorderRadius.all(Radius.circular(8.0))),
              child: Center(
                  child: Text(
                "${ImpossiblocksLocalizations.of(context).text("record")} $r",
                style: ResStyles.small(sizeScreen, color: Colors.white),
              )),
            ),
          )
        ],
      ),
    );
  }
}

class TopInfo extends StatelessWidget {
  final SizeScreen sizeScreen;

  final String name;

  final int data;

  final bool highlight;

  final Color color;

  final bool removePadding;

  TopInfo({
    Key key,
    @required this.sizeScreen,
    @required this.name,
    @required this.data,
    @required this.highlight,
    this.color,
    this.removePadding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color c =
        color != null ? color : highlight ? ResColors.colorTile1 : Colors.white;
    double size = Dimensions.getSizeIcon(sizeScreen, 70);
    return Container(
      constraints: BoxConstraints.expand(width: size, height: size),
      decoration: highlight
          ? new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(Radius.circular(10.0)))
          : null,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(name,
                maxLines: 1,
                style: ResStyles.normal(sizeScreen,
                    color: c, fontWeight: FontWeight.w700)),
            Padding(
              padding: EdgeInsets.only(top: removePadding ? 0 : 6.0),
              child: Text(data.toString(),
                  style: ResStyles.posintInTop(sizeScreen,
                      color: c, fontWeight: FontWeight.w700)),
            ),
          ]),
    );
  }
}

class TileCounterInfo extends StatelessWidget {
  final SizeScreen sizeScreen;

  final Color bgColor;

  final int counter;

  TileCounterInfo({
    Key key,
    @required this.sizeScreen,
    @required this.bgColor,
    @required this.counter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = Dimensions.getSizeIcon(sizeScreen, 64);
    return Container(
      constraints: BoxConstraints.expand(width: size, height: size),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius: new BorderRadius.all(Radius.circular(10.0))),
          child: Center(
            child: counter <= 0
                ? Icon(
                    Icons.thumb_up,
                    color: Colors.white,
                  )
                : Text(counter.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 34.0)),
          ),
        ),
      ),
    );
  }
}
