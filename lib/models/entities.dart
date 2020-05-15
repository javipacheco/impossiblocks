import "package:equatable/equatable.dart";

class WorldListEntity extends Equatable {
  final List<WorldEntity> worlds;

  WorldListEntity({this.worlds}) : super([worlds]);

  @override
  String toString() {
    return 'WorldListEntity{worlds: $worlds}';
  }

  Map<String, Object> toJson() {
    return {
      "worlds": worlds.map((w) => w.toJson()),
    };
  }

  factory WorldListEntity.fromJson(Map<String, dynamic> parsedJson) {
    var worlds = parsedJson['worlds'] as List<dynamic>;
    return WorldListEntity(
      worlds: worlds != null
          ? worlds.map((w) => WorldEntity.fromJson(w)).toList()
          : null,
    );
  }
}

class WorldEntity extends Equatable {
  final String name;
  final int world;
  final int levels;

  WorldEntity({this.name, this.world, this.levels})
      : super([name, world, levels]);

  WorldEntity copyWith({int name, int world, int levels}) {
    return WorldEntity(
        name: name ?? this.name,
        world: world ?? this.world,
        levels: levels ?? this.levels);
  }

  @override
  String toString() {
    return 'WorldEntity{name: $name, world: $world, levels: $levels}';
  }

  Map<String, Object> toJson() {
    return {
      "name": name,
      "world": world,
      "levels": levels,
    };
  }

  factory WorldEntity.fromJson(Map<String, dynamic> parsedJson) {
    return WorldEntity(
      name: parsedJson['name'],
      world: parsedJson['world'],
      levels: parsedJson['levels'],
    );
  }
}

class LevelEntity extends Equatable {
  final String levelType;
  final List<int> counters;
  final int rows;
  final int columns;
  final List<int> board;
  final LevelStarsEntity stars;
  final RandomBoardEntity randomBoard;
  final AssistanceEntity assistance;
  final bool showAds;

  LevelEntity(
      {this.levelType,
      this.counters,
      this.rows,
      this.columns,
      this.board,
      this.stars,
      this.randomBoard,
      this.assistance,
      this.showAds = true})
      : super([
          levelType,
          counters,
          rows,
          columns,
          board,
          stars,
          randomBoard,
          assistance,
          showAds,
        ]);

  LevelEntity copyWith({
    String levelType,
    List<int> counters,
    int rows,
    int columns,
    List<int> board,
    LevelStarsEntity stars,
    RandomBoardEntity randomBoard,
    AssistanceEntity assistance,
  }) {
    return LevelEntity(
      levelType: levelType ?? this.levelType,
      counters: counters ?? this.counters,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      board: board ?? this.board,
      stars: stars ?? this.stars,
      randomBoard: randomBoard ?? this.randomBoard,
      assistance: assistance ?? this.assistance,
    );
  }

  int getStars(int moves) {
    if (moves <= stars.hight) {
      return 3;
    } else if (moves <= stars.middle) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  String toString() {
    return 'Level{levelType: $levelType, counters: $counters, rows: $rows, columns: $columns, board: $board, stars: $stars, randomBoard: $randomBoard, assistance: $assistance, showAds: $showAds}';
  }

  Map<String, Object> toJson() {
    return {
      "levelType": levelType,
      "counters": counters,
      "rows": rows,
      "columns": columns,
      "board": board.toList(),
      "stars": stars.toJson(),
      "randomBoard": randomBoard.toJson(),
      "assistance": assistance.toJson(),
      "showAds": showAds,
    };
  }

  factory LevelEntity.fromJson(Map<String, dynamic> parsedJson) {
    var counter = parsedJson['counters'];
    var board = parsedJson['board'];
    var randomBoard = parsedJson['randomBoard'];
    var assistance = parsedJson['assistance'];
    return LevelEntity(
      levelType: parsedJson['levelType'],
      counters: counter != null ? List<int>.from(counter) : null,
      rows: parsedJson['rows'],
      columns: parsedJson['columns'],
      board: board != null ? List<int>.from(board) : null,
      stars: LevelStarsEntity.fromJson(parsedJson['stars']),
      randomBoard:
          randomBoard != null ? RandomBoardEntity.fromJson(randomBoard) : null,
      assistance:
          assistance != null ? AssistanceEntity.fromJson(assistance) : null,
      showAds: parsedJson['showAds'] ?? true,
    );
  }
}

class LevelStarsEntity extends Equatable {
  final int hight;
  final int middle;

  LevelStarsEntity({
    this.hight,
    this.middle,
  }) : super([hight, middle]);

  @override
  String toString() {
    return 'LevelStarsEntity{hight: $hight, middle: $middle}';
  }

  Map<String, Object> toJson() {
    return {"hight": hight, "middle": middle};
  }

  factory LevelStarsEntity.fromJson(Map<String, dynamic> parsedJson) {
    return LevelStarsEntity(
      hight: parsedJson['hight'],
      middle: parsedJson['middle'],
    );
  }
}

class RandomBoardEntity extends Equatable {
  final String typeTile;
  final int difficulty;

  RandomBoardEntity({
    this.typeTile,
    this.difficulty,
  }) : super([typeTile, difficulty]);

  @override
  String toString() {
    return 'RandomTilesEntity{typeTile: $typeTile, difficulty: $difficulty}';
  }

  Map<String, Object> toJson() {
    return {"typeTile": typeTile, "difficulty": difficulty};
  }

  factory RandomBoardEntity.fromJson(Map<String, dynamic> parsedJson) {
    return RandomBoardEntity(
      typeTile: parsedJson['typeTile'],
      difficulty: parsedJson['difficulty'],
    );
  }
}

class AssistanceEntity extends Equatable {
  final int coins;
  final AssistanceItemEntity fireman;
  final AssistanceItemEntity ray;
  final AssistanceItemEntity brush;
  final AssistanceItemEntity block;

  AssistanceEntity({
    this.coins,
    this.fireman,
    this.ray,
    this.brush,
    this.block,
  }) : super([coins, fireman, ray, brush, block]);

  @override
  String toString() {
    return 'AssistanceEntity{coins: $coins, fireman: $fireman, ray: $ray, brush: $brush, block: $block}';
  }

  Map<String, Object> toJson() {
    return {
      "coins": coins,
      "fireman": fireman,
      "ray": ray,
      "brush": brush,
      "block": block
    };
  }

  factory AssistanceEntity.fromJson(Map<String, dynamic> parsedJson) {
    var fireman = parsedJson['fireman'];
    var ray = parsedJson['ray'];
    var brush = parsedJson['brush'];
    var block = parsedJson['block'];
    return AssistanceEntity(
      coins: parsedJson['coins'],
      fireman: fireman != null ? AssistanceItemEntity.fromJson(fireman) : null,
      ray: ray != null ? AssistanceItemEntity.fromJson(ray) : null,
      brush: brush != null ? AssistanceItemEntity.fromJson(brush) : null,
      block: block != null ? AssistanceItemEntity.fromJson(block) : null,
    );
  }
}

class AssistanceItemEntity extends Equatable {
  final int afterMoves;

  AssistanceItemEntity({
    this.afterMoves,
  }) : super([afterMoves]);

  @override
  String toString() {
    return 'AssistanceItemEntity{afterMoves: $afterMoves}';
  }

  Map<String, Object> toJson() {
    return {"afterMoves": afterMoves};
  }

  factory AssistanceItemEntity.fromJson(Map<String, dynamic> parsedJson) {
    return AssistanceItemEntity(
      afterMoves: parsedJson['afterMoves'],
    );
  }
}
