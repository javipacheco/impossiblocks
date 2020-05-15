import 'package:flutter/foundation.dart';
import "package:equatable/equatable.dart";

@immutable
class WorldsState extends Equatable {
  final String name;

  final int world;

  final int levels;

  WorldsState({
    @required this.name,
    @required this.world,
    @required this.levels,
  }) : super([name, world, levels]);

  @override
  String toString() {
    return 'WorldsState{name: $name, world: $world, levels: $levels}';
  }
}

@immutable
class WorldsCompletedState extends Equatable {
  final int world;

  final int levelsCompleted;

  final bool completed;

  WorldsCompletedState({
    @required this.world,
    @required this.levelsCompleted,
    @required this.completed,
  }) : super([world, levelsCompleted, completed]);

  @override
  String toString() {
    return 'WorldsCompletedState{world: $world, levelsCompleted: $levelsCompleted, completed: $completed}';
  }
}

@immutable
class LevelListState extends Equatable {
  final List<WorldsState> worlds;

  final List<WorldsCompletedState> worldsCompleted;

  final bool loading;

  final int currentWorld;

  final int currentLevel;

  final List<LevelState> levels;

  final int coins;

  LevelListState({
    @required this.currentWorld,
    @required this.currentLevel,
    @required this.levels,
    @required this.worlds,
    @required this.worldsCompleted,
    this.loading = false,
    this.coins = 0,
  }) : super([
          currentWorld,
          currentLevel,
          levels,
          worlds,
          worldsCompleted,
          loading,
          coins
        ]);

  int getStarsForCurrentLevel() {
    LevelState level = levels.firstWhere(
        (i) => i.world == currentWorld && i.number == currentLevel,
        orElse: () => null);
    return level?.stars ?? 0;
  }

  WorldsState getWorld() {
    return worlds.firstWhere((w) => w.world == currentWorld);
  }

  WorldsCompletedState getWorldsCompleted(int world) {
    return worldsCompleted.firstWhere((w) => w.world == world,
        orElse: () => null);
  }

  bool isLastLevel() {
    return currentLevel >= getWorld().levels;
  }

  factory LevelListState.empty() {
    return LevelListState(
        levels: List(),
        worlds: List(),
        worldsCompleted: List(),
        currentWorld: 1,
        currentLevel: 1,);
  }

  LevelListState copyWith({
    worlds,
    worldsCompleted,
    loading,
    levels,
    currentWorld,
    currentLevel,
    coins
  }) {
    return LevelListState(
      worlds: worlds ?? this.worlds,
      worldsCompleted: worldsCompleted ?? this.worldsCompleted,
      loading: loading ?? this.loading,
      levels: levels ?? this.levels,
      currentWorld: currentWorld ?? this.currentWorld,
      currentLevel: currentLevel ?? this.currentLevel,
      coins: coins ?? this.coins,
    );
  }

  @override
  String toString() {
    return 'LevelListState{worlds: $worlds, worldsCompleted: $worldsCompleted, loading: $loading, levels: $levels, currentWorld: $currentWorld, currentLevel: $currentLevel, coins: $coins}';
  }
}

@immutable
class LevelState extends Equatable {
  final int world;
  final int number;
  final bool done;
  final int stars;

  LevelState({this.world, this.number, this.done, this.stars})
      : super([world, number, done, stars]);

  @override
  String toString() {
    return 'LevelState{wolrd: $world, number: $number, done: $done, stars: $stars}';
  }
}
