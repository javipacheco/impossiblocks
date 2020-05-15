import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/modules/modules.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/main/medals.dart';
import 'package:impossiblocks/ui/main/viewmodels/main_container_view_model.dart';
import 'package:impossiblocks/ui/widgets/cubes_background.dart';
import 'package:impossiblocks/ui/widgets/horizontal_radio_buttons.dart';
import 'package:impossiblocks/ui/widgets/marquee.dart';
import 'package:impossiblocks/ui/widgets/rounded_container.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/navigation/routes.dart';
import 'main_button.dart';

class MainContainer extends StatelessWidget {
  const MainContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MainContainerViewModel>(
        distinct: true,
        converter: (store) => MainContainerViewModel.build(store, UserModule()),
        onInitialBuild: (viewModel) {
          viewModel.onLoadSizeBoard();
          viewModel.onInitialLevels();
        },
        builder: (context, viewModel) {
          return RoundedContainer(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: CubesBackground()),
                  LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                          ),
                          child: viewModel.sizeScreen != null &&
                                  viewModel.sizeScreen == SizeScreen.NANO
                              ? buildNanoScreen(context, viewModel)
                              : viewModel.sizeScreen != null &&
                                      viewModel.sizeScreen == SizeScreen.SMALL
                                  ? buildSmallScreen(context, viewModel)
                                  : buildNormalScreen(context, viewModel),
                        ),
                      );
                    },
                  ),
                ],
              ));
        });
  }

  Column buildNormalScreen(
      BuildContext context, MainContainerViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (viewModel.sizeScreen == SizeScreen.BIG)
          buildMessage(
              ImpossiblocksLocalizations.of(context).text("level_msg")),
        buildGap(viewModel.sizeScreen),
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("levels"),
          asset: "ic_levels",
          onTap: () => Navigator.pushNamed(context, ImpossiblocksRoutes.levels),
        ),
        buildGap(viewModel.sizeScreen),
        buildMedalsIcons(viewModel),
        buildGap(viewModel.sizeScreen),
        Divider(color: ResColors.primaryColorDark),
        buildGap(viewModel.sizeScreen),
        if (viewModel.sizeScreen == SizeScreen.BIG)
          buildMessage(
              ImpossiblocksLocalizations.of(context).text("games_msg")),
        buildGap(viewModel.sizeScreen),
        buildHorizontalRadioButtons(viewModel),
        buildGap(viewModel.sizeScreen),
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("arcade"),
          asset: "ic_arcade",
          onTap: () {
            viewModel.onLoadArcadeGame();
            Navigator.pushNamed(context, ImpossiblocksRoutes.levelsGame);
          },
        ),
        buildMarquee([
          buildMarqueeText(
              ImpossiblocksLocalizations.of(context).text("arcade_msg")),
          buildMarqueeText(ImpossiblocksLocalizations.of(context).replaceText(
              "rank_msg",
              "0",
              viewModel.onUserRank(TypeBoardGame.ARCADE).toString()))
        ]),
        buildGap(viewModel.sizeScreen),
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("classic"),
          asset: "ic_classic",
          onTap: () {
            viewModel.onLoadClassicGame();
            Navigator.pushNamed(context, ImpossiblocksRoutes.levelsGame);
          },
        ),
        buildMarquee([
          buildMarqueeText(
              ImpossiblocksLocalizations.of(context).text("classic_msg")),
          buildMarqueeText(ImpossiblocksLocalizations.of(context).replaceText(
              "rank_msg",
              "0",
              viewModel.onUserRank(TypeBoardGame.CLASSIC).toString())),
        ]),
        buildGap(viewModel.sizeScreen),
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("two_players"),
          asset: "ic_two_players",
          onTap: () {
            viewModel.onLoadTwoPlayersGame();
            Navigator.pushNamed(context, ImpossiblocksRoutes.twoPlayers);
          },
        ),
      ],
    );
  }

  Column buildSmallScreen(
      BuildContext context, MainContainerViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("levels"),
          asset: "ic_levels",
          onTap: () => Navigator.pushNamed(context, ImpossiblocksRoutes.levels),
        ),
        buildGap(viewModel.sizeScreen),
        buildMedalsIcons(viewModel),
        buildGap(viewModel.sizeScreen),
        Divider(color: ResColors.primaryColorDark),
        buildGap(viewModel.sizeScreen),
        buildHorizontalRadioButtons(viewModel),
        buildGap(viewModel.sizeScreen),
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("arcade"),
          asset: "ic_arcade",
          onTap: () {
            viewModel.onLoadArcadeGame();
            Navigator.pushNamed(context, ImpossiblocksRoutes.levelsGame);
          },
        ),
        buildMarquee([
          buildMarqueeText(
              ImpossiblocksLocalizations.of(context).text("arcade_msg")),
          buildMarqueeText(ImpossiblocksLocalizations.of(context).replaceText(
              "rank_msg",
              "0",
              viewModel.onUserRank(TypeBoardGame.ARCADE).toString()))
        ]),
        buildGap(viewModel.sizeScreen),
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("classic"),
          asset: "ic_classic",
          onTap: () {
            viewModel.onLoadClassicGame();
            Navigator.pushNamed(context, ImpossiblocksRoutes.levelsGame);
          },
        ),
        buildMarquee([
          buildMarqueeText(
              ImpossiblocksLocalizations.of(context).text("classic_msg")),
          buildMarqueeText(ImpossiblocksLocalizations.of(context).replaceText(
              "rank_msg",
              "0",
              viewModel.onUserRank(TypeBoardGame.CLASSIC).toString())),
        ]),
      ],
    );
  }

  Column buildNanoScreen(
      BuildContext context, MainContainerViewModel viewModel) {
    int levelsCompleted = viewModel.countLevelCompleted();
    int maxLevels = 6;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("levels"),
          asset: "ic_levels",
          onTap: () => Navigator.pushNamed(context, ImpossiblocksRoutes.levels),
        ),
        buildMedalTexts(viewModel, levelsCompleted, maxLevels, context),
        Divider(color: ResColors.primaryColorDark),
        buildHorizontalRadioButtons(viewModel),
        buildGap(viewModel.sizeScreen),
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("arcade"),
          asset: "ic_arcade",
          onTap: () {
            viewModel.onLoadArcadeGame();
            Navigator.pushNamed(context, ImpossiblocksRoutes.levelsGame);
          },
        ),
        buildMarquee([
          buildMarqueeText(
              ImpossiblocksLocalizations.of(context).text("arcade_msg")),
          buildMarqueeText(ImpossiblocksLocalizations.of(context).replaceText(
              "rank_msg",
              "0",
              viewModel.onUserRank(TypeBoardGame.ARCADE).toString()))
        ]),
        buildGap(viewModel.sizeScreen),
        MainButton(
          sizeScreen: viewModel.sizeScreen,
          title: ImpossiblocksLocalizations.of(context).text("classic"),
          asset: "ic_classic",
          onTap: () {
            viewModel.onLoadClassicGame();
            Navigator.pushNamed(context, ImpossiblocksRoutes.levelsGame);
          },
        ),
        buildMarquee([
          buildMarqueeText(
              ImpossiblocksLocalizations.of(context).text("classic_msg")),
          buildMarqueeText(ImpossiblocksLocalizations.of(context).replaceText(
              "rank_msg",
              "0",
              viewModel.onUserRank(TypeBoardGame.CLASSIC).toString())),
        ]),
      ],
    );
  }

  Padding buildMarquee(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Marquee(children: children),
    );
  }

  SizedBox buildGap(SizeScreen sizeScreen) => SizedBox(
      height: sizeScreen == SizeScreen.NANO
          ? 10
          : sizeScreen == SizeScreen.SMALL
              ? 14
              : sizeScreen == SizeScreen.BIG ? 30 : 16);

  HorizontalRadioButtons buildHorizontalRadioButtons(
      MainContainerViewModel viewModel) {
    return HorizontalRadioButtons(
      sizeScreen: viewModel.sizeScreen,
      normalColor: Colors.white,
      selectedColor: ResColors.colorTile1,
      items: ["3x3", "4x4", "5x5"],
      itemSelected: viewModel.boardSelected == SizeBoardGame.X3_3
          ? "3x3"
          : viewModel.boardSelected == SizeBoardGame.X4_4 ? "4x4" : "5x5",
      onTap: (position) {
        viewModel.onChangeSizeBoard(position == 0
            ? SizeBoardGame.X3_3
            : position == 1 ? SizeBoardGame.X4_4 : SizeBoardGame.X5_5);
      },
      disabled: [],
    );
  }

  Widget buildMedalsIcons(MainContainerViewModel viewModel) {
    return Medals(
      items: List.generate(
          6,
          (i) =>
              Medal(world: i + 1, achieved: viewModel.isLevelCompleted(i))),
      normalColor: Colors.grey,
      selectedColor: ResColors.colorTile1,
    );
  }

  Widget buildMedalTexts(MainContainerViewModel viewModel, int levelsCompleted,
      int maxLevels, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildMarqueeText(levelsCompleted >= maxLevels
          ? ImpossiblocksLocalizations.of(context)
              .text("all_levels_completed")
          : ImpossiblocksLocalizations.of(context).replaceTextMap(
              "number_levels_completed",
              {"01": "$levelsCompleted", "02": "$maxLevels"})),
    );
  }

  Text buildMessage(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: ResStyles.titleMainScreen,
    );
  }

  Text buildMarqueeText(String text) {
    return Text(
      text,
      style: ResStyles.subtitleMainScreen,
    );
  }
}
