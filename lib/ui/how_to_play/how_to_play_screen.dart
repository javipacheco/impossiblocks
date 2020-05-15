import 'dart:math';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/flare/loop_controller.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';
import 'package:impossiblocks/ui/widgets/dialogs/common_dialog_view_model.dart';

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.black54,
  }) : super(listenable: controller);

  final PageController controller;

  final int itemCount;

  final ValueChanged<int> onPageSelected;

  final Color color;

  static const double _kDotSize = 8.0;

  static const double _kMaxZoom = 2.0;

  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

class HowToPlayScreen extends StatefulWidget {
  final bool arcade;
  HowToPlayScreen({Key key, this.arcade}) : super(key: key);
  @override
  State createState() => new HowToPlayScreenState();
}

class HowToPlayScreenState extends State<HowToPlayScreen> {
  static final LoopController _loopController = LoopController('success', 5);

  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  List<Widget> getArcadePages(SizeScreen sizeScreen) => <Widget>[
        assistancePage(
            sizeScreen,
            ImpossiblocksLocalizations.of(context)
                .text("how_to_play_assistance")),
        burshAssistancePage(sizeScreen,
            ImpossiblocksLocalizations.of(context).text("how_to_play_brush")),
        blockAssistancePage(
            sizeScreen,
            ImpossiblocksLocalizations.of(context)
                .text("how_to_play_block_arcade")),
        othersAssistancePage(
            sizeScreen,
            ImpossiblocksLocalizations.of(context)
                .text("how_to_play_fire_lightning")),
      ];

  List<Widget> getClassicPages(SizeScreen sizeScreen) => <Widget>[
        flarePage(
            sizeScreen,
            ImpossiblocksLocalizations.of(context).text("level_msg_1_1"),
            "assets/flare/level_1_1.flr"),
        flarePage(
            sizeScreen,
            ImpossiblocksLocalizations.of(context).text("how_to_play_slide"),
            "assets/flare/level_2_1.flr"),
        flarePage(
            sizeScreen,
            ImpossiblocksLocalizations.of(context).text("how_to_play_block"),
            "assets/flare/level_2_3.flr"),
      ];

  ConstrainedBox assistancePage(SizeScreen sizeScreen, String text) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16.0, height: 1.4),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                height: 180,
                child: Center(
                    child: AssistanceBar(
                  sizeScreen: SizeScreen.NORMAL,
                  playersGame: PlayersGame.ONE,
                )))
          ],
        ));
  }

  ConstrainedBox burshAssistancePage(SizeScreen sizeScreen, String text) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16.0, height: 1.4),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                height: 180,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AssistanceAction(
                      sizeScreen: sizeScreen,
                      assistanceActionType: AssistanceActionType.BRUSH1,
                      assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
                      coins: 15,
                      moves: 0,
                      onTap: (_) {},
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    AssistanceAction(
                      sizeScreen: sizeScreen,
                      assistanceActionType: AssistanceActionType.BRUSH2,
                      assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
                      coins: 15,
                      moves: 0,
                      onTap: (_) {},
                    ),
                  ],
                )))
          ],
        ));
  }

  ConstrainedBox blockAssistancePage(SizeScreen sizeScreen, String text) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16.0, height: 1.4),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                height: 180,
                child: Center(
                  child: AssistanceAction(
                    sizeScreen: sizeScreen,
                    assistanceActionType: AssistanceActionType.BLOCK,
                    assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
                    coins: 15,
                    moves: 0,
                    onTap: (_) {},
                  ),
                ))
          ],
        ));
  }

  ConstrainedBox othersAssistancePage(SizeScreen sizeScreen, String text) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16.0, height: 1.4),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                height: 180,
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AssistanceAction(
                      sizeScreen: sizeScreen,
                      assistanceActionType: AssistanceActionType.FIREMAN,
                      assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
                      coins: 15,
                      moves: 0,
                      onTap: (_) {},
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    AssistanceAction(
                      sizeScreen: sizeScreen,
                      assistanceActionType: AssistanceActionType.LIGHTNING,
                      assistanceItemStatus: AssistanceItemStatus(afterMoves: 0),
                      coins: 15,
                      moves: 0,
                      onTap: (_) {},
                    ),
                  ],
                )))
          ],
        ));
  }

  ConstrainedBox flarePage(
      SizeScreen sizeScreen, String text, String flareFile) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16.0, height: 1.4),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 180,
              height: 180,
              child: FlareActor(
                flareFile,
                alignment: Alignment.center,
                fit: BoxFit.contain,
                controller: _loopController,
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black54,
          ),
          title: Center(
            child: Text(
                ImpossiblocksLocalizations.of(context).text("how_to_play"),
                style: ResStyles.howToPlayTitleScreen),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: SizedBox.shrink(),
              onPressed: null,
            ),
          ],
        ),
        body: StoreConnector<AppState, CommonDialogViewModel>(
            distinct: true,
            converter: (store) => CommonDialogViewModel.build(store),
            builder: (context, viewModel) {
              List<Widget> _pages = widget.arcade
                  ? getArcadePages(viewModel.sizeScreen)
                  : getClassicPages(viewModel.sizeScreen);
              return new IconTheme(
                data: new IconThemeData(color: _kArrowColor),
                child: new Stack(
                  children: <Widget>[
                    new PageView.builder(
                      itemCount: _pages.length,
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index) {
                        return _pages[index % _pages.length];
                      },
                    ),
                    new Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: new Container(
                        padding: const EdgeInsets.all(20.0),
                        child: new Center(
                          child: new DotsIndicator(
                            controller: _controller,
                            itemCount: _pages.length,
                            onPageSelected: (int page) {
                              _controller.animateToPage(
                                page,
                                duration: _kDuration,
                                curve: _kCurve,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
