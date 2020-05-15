import 'package:impossiblocks/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/modules/user_module.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/ui/widgets/rounded_container.dart';
import 'world_card_view.dart';
import 'viewmodels/level_list_container_view_model.dart';
import 'levels_grid.dart';

class LevelsListContainer extends StatefulWidget {
  LevelsListContainer({Key key}) : super(key: key);

  _LevelsListContainerState createState() => _LevelsListContainerState();
}

class _LevelsListContainerState extends State<LevelsListContainer> {
  PageController pageController;
  var currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LevelListContainerViewModel>(
      distinct: true,
      converter: (store) =>
          LevelListContainerViewModel.build(store, UserModule()),
      onInitialBuild: (viewModel) {
        viewModel.onInitialLevels();
        pageController.jumpToPage(viewModel.levels.currentWorld - 1);
      },
      builder: (context, viewModel) {
        List<List<LevelState>> groupLevels = List.generate(viewModel.levels.worlds.length, (i) => i).map((index) {
          var world = viewModel.levels.worlds[index];
          return viewModel.levels.levels
              .where((level) => level.world == world.world)
              .toList();
        }).toList();

        return Container(
          child: Stack(
            children: <Widget>[
              RoundedContainer(
                color: ResColors.colorTile1,
                child: WorldCardsView(
                  sizeScreen: viewModel.sizeScreen,
                  levelList: viewModel.levels,
                  world: viewModel.levels.currentWorld,
                  onPrevWorld: () {
                    if (viewModel.levels.currentWorld > 1)
                      pageController.animateToPage(
                          (viewModel.levels.currentWorld - 1) - 1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                  },
                  onNextWorld: () {
                    if (viewModel.levels.currentWorld <
                        viewModel.levels.worlds.length)
                      pageController.animateToPage(
                          (viewModel.levels.currentWorld - 1) + 1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                  },
                ),
                padding: EdgeInsets.only(top: 24),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimensions.worldsHeightContainer(viewModel.sizeScreen)),
                child: RoundedContainer(
                  color: Colors.white,
                  bgColor: ResColors.colorTile1,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollEndNotification) {
                        viewModel.onLoadWorld(pageController.page.round());
                      }
                      return true;
                    },
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: viewModel.levels.worlds.length,
                      itemBuilder: (context, index) {
                        var world = viewModel.levels.worlds[index];
                        List<LevelState> levels = groupLevels[index];
                        if (index == currentPageValue.floor() || index == currentPageValue.floor() + 1) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..rotateY(currentPageValue - index)
                              ..rotateZ(currentPageValue - index),
                            child: buildLevels(viewModel, levels, world.world),
                          );
                        } else {
                          return buildLevels(viewModel, levels, world.world);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLevels(LevelListContainerViewModel viewModel,
      List<LevelState> levels, int world) {
    return LevelsGrid(
        levelList: viewModel.levels,
        levels: levels,
        world: world,
        sizeScreen: viewModel.sizeScreen,
        onTapItem: (levelState) => viewModel.onLevelClick(context, levelState));
  }
}
