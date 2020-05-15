import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/navigation/navigation.dart';
import 'level_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LevelsGrid extends StatelessWidget {
  final LevelListState levelList;

  final List<LevelState> levels;
  
  final int world;

  final SizeScreen sizeScreen;

  final Function(LevelState) onTapItem;

  const LevelsGrid({
    Key key,
    @required this.levelList,
    @required this.levels,
    @required this.world,
    @required this.sizeScreen,
    @required this.onTapItem,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return GridView.builder(
      key: ImpossiblocksKeys.levelList,
      shrinkWrap: false,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 3),
      itemCount: levels.length,
      itemBuilder: (BuildContext context, int index) {
        final level = levels[index];
        bool isPlayable = index == 0
            ? world == 1
                ? true
                : levelList
                    .getWorldsCompleted(world - 1)
                    .completed
            : levels[index - 1].done;
        return LevelItem(
          isPlayable: isPlayable,
          onTap: () => onTapItem(level),
          level: level,
          sizeScreen: sizeScreen,
        );
      },
    );
  }
}
