import 'dart:math';
import "package:equatable/equatable.dart";
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';
import 'package:impossiblocks/utils/list_utils.dart';

enum PlayersGame { ONE, TWO }

enum TypeBoardGame { LEVEL, CLASSIC, ARCADE }

enum TypeBoardLevel { MOVEMENT_COUNTER, COLOR_COUNTER }

enum TypeTile { NORMAL, BLOCKED, FIRE, LIGHTNING }

enum LeadboardGames {
  X3_3_ARCADE,
  X4_4_ARCADE,
  X5_5_ARCADE,
  X3_3_CLASSIC,
  X4_4_CLASSIC,
  X5_5_CLASSIC
}

@immutable
class BoardStatus extends Equatable {
  final int rows;
  final int columns;
  final int allMoves;
  final int moves;
  final List<TileStatus> tiles;
  final TypeBoardGame typeBoard;
  final TypeBoardLevel typeLevel;
  final bool blocked;
  final TypeTile typeTile;
  final int difficulty;
  final AssistanceStatus assistance;
  final bool lightningBlocked;

  final _random = new Random();

  BoardStatus({
    @required this.rows,
    @required this.columns,
    @required this.allMoves,
    @required this.moves,
    @required this.tiles,
    @required this.typeBoard,
    @required this.typeLevel,
    @required this.blocked,
    this.typeTile = TypeTile.NORMAL,
    this.difficulty = 0,
    this.assistance,
    this.lightningBlocked = false,
  }) : super([
          rows,
          columns,
          allMoves,
          moves,
          tiles,
          typeBoard,
          typeLevel,
          blocked,
          typeTile,
          difficulty,
          assistance,
          lightningBlocked
        ]);

  factory BoardStatus.empty() {
    return BoardStatus(
      rows: 0,
      columns: 0,
      allMoves: 0,
      moves: 0,
      tiles: List(),
      typeBoard: TypeBoardGame.LEVEL,
      typeLevel: TypeBoardLevel.MOVEMENT_COUNTER,
      blocked: false,
      lightningBlocked: false,
    );
  }

  factory BoardStatus.random(SizeBoardGame sizeBoardGame) {
    List<int> values = [0, 0];
    if (sizeBoardGame == SizeBoardGame.X3_3) {
      values = [3, 3];
    } else if (sizeBoardGame == SizeBoardGame.X4_4) {
      values = [4, 4];
    } else if (sizeBoardGame == SizeBoardGame.X5_5) {
      values = [5, 5];
    }
    return BoardStatus.empty()
        .copyWith(rows: values[0], columns: values[1])
        .random();
  }

  LeadboardGames getLeadboardGames() {
    switch (typeBoard) {
      case TypeBoardGame.ARCADE:
        return columns == 5 && rows == 5
            ? LeadboardGames.X5_5_ARCADE
            : columns == 4 && rows == 4
                ? LeadboardGames.X4_4_ARCADE
                : LeadboardGames.X3_3_ARCADE;
        break;
      case TypeBoardGame.CLASSIC:
        return columns == 5 && rows == 5
            ? LeadboardGames.X5_5_CLASSIC
            : columns == 4 && rows == 4
                ? LeadboardGames.X4_4_CLASSIC
                : LeadboardGames.X3_3_CLASSIC;
        break;
      case TypeBoardGame.LEVEL:
        return null;
        break;
    }
    return null;
  }

  BoardStatus block() {
    return copyWith(blocked: true);
  }

  BoardStatus unblock() {
    return copyWith(blocked: false);
  }

  BoardStatus blockTiles(List<int> positions) {
    return copyWith(
        allMoves: allMoves + 1,
        moves: moves + 1,
        tiles: List.generate(rows * columns, (i) {
          TileStatus status = tiles[i];
          TypeTile tt = status.typeTile == TypeTile.NORMAL
              ? TypeTile.BLOCKED
              : status.typeTile;
          return positions.contains(i) ? status.copyWith(typeTile: tt) : status;
        }));
  }

  BoardStatus unblockTile(int position) {
    return copyWith(
        allMoves: allMoves + 1,
        moves: moves + 1,
        tiles: List.generate(
            rows * columns,
            (i) => i == position
                ? tiles[i].copyWith(typeTile: TypeTile.NORMAL)
                : tiles[i]));
  }

  bool isTileBlocked(int position) {
    return tiles[position] != null && tiles[position].typeTile == TypeTile.BLOCKED;
  }

  BoardStatus changeTiles(List<TileStatus> tiles) {
    return copyWith(allMoves: allMoves + 1, moves: moves + 1, tiles: tiles);
  }

  BoardStatus resetAllMoves() {
    return copyWith(allMoves: 0, moves: 0);
  }

  BoardStatus resetMoves() {
    return copyWith(moves: 0);
  }

  BoardStatus random() {
    List<int> itemsWithTypeTile = List.generate(difficulty, (int i) => i)
        .fold<List<int>>(List<int>(), (list, index) {
      int pos = _random.nextInt(rows * columns);
      while (list.contains(pos)) {
        pos++;
        if (pos >= rows * columns) pos = 0;
      }
      list.add(pos);
      return list;
    });

    int number() {
      return _random.nextInt(50) % 2;
    }

    BoardStatus board = copyWith(
        tiles: List.generate(rows * columns, (int i) => i)
            .map((i) => TileStatus(
                color: number(),
                typeTile:
                    itemsWithTypeTile.contains(i) ? typeTile : TypeTile.NORMAL))
            .toList());

    return board.isSuccess() && board.tiles.length > 4
        ? board.setValue(4, board.tiles[4].color == 1 ? 0 : 1)
        : board;
  }

  BoardStatus copyWith({
    rows,
    columns,
    allMoves,
    moves,
    tiles,
    typeBoard,
    typeLevel,
    blocked,
    typeTile,
    difficulty,
    assistance,
    rayBlocked,
  }) {
    return BoardStatus(
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      allMoves: allMoves ?? this.allMoves,
      moves: moves ?? this.moves,
      tiles: tiles ?? this.tiles,
      typeBoard: typeBoard ?? this.typeBoard,
      typeLevel: typeLevel ?? this.typeLevel,
      blocked: blocked ?? this.blocked,
      typeTile: typeTile ?? this.typeTile,
      difficulty: difficulty ?? this.difficulty,
      assistance: assistance ?? this.assistance,
      lightningBlocked: rayBlocked ?? this.lightningBlocked,
    );
  }

  bool isAssistanceCompleted(AssistanceActionType assistanceActionType) {
    int movesForFree;
    switch (assistanceActionType) {
      case AssistanceActionType.BLOCK:
        movesForFree = assistance?.block?.afterMoves;
        break;
      case AssistanceActionType.BRUSH1:
      case AssistanceActionType.BRUSH2:
        movesForFree = assistance?.brush?.afterMoves;
        break;
      case AssistanceActionType.FIREMAN:
        movesForFree = assistance?.fireman?.afterMoves;
        break;
      case AssistanceActionType.LIGHTNING:
        movesForFree = assistance?.ray?.afterMoves;
        break;
    }
    return movesForFree != null ? movesForFree <= moves : true;
  }

  BoardStatus assistanceUsed(AssistanceActionType assistanceActionType) {
    return copyWith(
        assistance: assistance.copyWith(
      fireman: assistance.fireman != null &&
              assistanceActionType == AssistanceActionType.FIREMAN
          ? assistance.fireman.copyWith(uses: assistance.fireman.uses - 1)
          : assistance.fireman,
      block: assistance.block != null &&
              assistanceActionType == AssistanceActionType.BLOCK
          ? assistance.block.copyWith(uses: assistance.block.uses - 1)
          : assistance.block,
      ray: assistance.ray != null &&
              assistanceActionType == AssistanceActionType.LIGHTNING
          ? assistance.ray.copyWith(uses: assistance.ray.uses - 1)
          : assistance.ray,
      brush: assistance.brush != null &&
              (assistanceActionType == AssistanceActionType.BRUSH1 ||
                  assistanceActionType == AssistanceActionType.BRUSH2)
          ? assistance.brush.copyWith(uses: assistance.brush.uses - 1)
          : assistance.brush,
    ));
  }

  BoardStatus addMovement(Movement movement) {
    BoardStatus getMinimumMovements(
        List<Movement> movements, bool hasFire, List<bool> randomFires) {
      return copyWith(allMoves: allMoves + 1, moves: moves + 1)
          ._change(
              movements[0],
              hasFire && ListUtils.getBool(randomFires, 0)
                  ? TypeTile.FIRE
                  : null)
          ._change(
              movements[1],
              hasFire && ListUtils.getBool(randomFires, 1)
                  ? TypeTile.FIRE
                  : null)
          ._change(
              movements[2],
              hasFire && ListUtils.getBool(randomFires, 2)
                  ? TypeTile.FIRE
                  : null)
          ._change(
              movements[3],
              hasFire && ListUtils.getBool(randomFires, 3)
                  ? TypeTile.FIRE
                  : null)
          ._change(
              movements[4],
              hasFire && ListUtils.getBool(randomFires, 4)
                  ? TypeTile.FIRE
                  : null);
    }

    Movement up = movement.getMovement(Position.UP);
    Movement down = movement.getMovement(Position.DOWN);
    Movement left = movement.getMovement(Position.LEFT);
    Movement right = movement.getMovement(Position.RIGHT);
    List<Movement> movements = [movement, up, down, left, right];

    bool hasLightning =
        !lightningBlocked && hasElement(movements, TypeTile.LIGHTNING);
    if (hasLightning) {
      BoardStatus b = getMinimumMovements(movements, false, []);
      return getRandomLightning(movements)
          .fold(b, (b, m) => b._change(m, null, flicker: true));
    } else {
      bool hasFire = hasElement(movements, TypeTile.FIRE);
      List<bool> randomFires =
          hasFire ? getRandomFires([movement, up, down, left, right]) : [];
      return getMinimumMovements(movements, hasFire, randomFires);
    }
  }

  BoardStatus _change(Movement movement, TypeTile typeTile,
      {bool flicker = false}) {
    if (movement != null) {
      int position = movement.getPosition();
      TileStatus v = getValue(position);
      return setValue(position,
          v.typeTile == TypeTile.BLOCKED ? v.color : v.color == 0 ? 1 : 0,
          typeTile: typeTile, flicker: flicker);
    } else {
      return this;
    }
  }

  BoardStatus addFlicker(int position) {
    var t = tiles;
    t[position] = t[position].copyWith(flicker: true);
    return copyWith(tiles: t);
  }

  BoardStatus removeFlicker(int position) {
    var t = tiles;
    t[position] = t[position].copyWith(flicker: false);
    return copyWith(tiles: t);
  }

  List<bool> getRandomFires(List<Movement> movements) {
    // El número de fuegos que se expanden serán en relación a la
    // dificultad y el tamaño del tablero
    var numberOfFires = max(difficulty + (rows - 3), 1);
    return movements.map((e) {
      if (e == null) return false;
      TileStatus ts = getValue(e.getPosition());
      if (ts.typeTile == TypeTile.NORMAL && numberOfFires > 0) {
        numberOfFires--;
        return true;
      } else
        return false;
    }).toList();
  }

  List<Movement> getRandomLightning(List<Movement> movements) {
    // El número de rays ejecutados serán en relación a la
    // dificultad y el tamaño del tablero
    movements.removeWhere((m) => m == null);
    List<int> positions = List.generate(rows * columns, (i) => i);
    positions.shuffle(_random);
    var numberOfRays = min(difficulty + (rows - 3), 1);
    List<Movement> rayMovements = positions.map((i) {
      if (!movements.map((m) => m.getPosition()).contains(i) &&
          numberOfRays > 0) {
        numberOfRays--;
        return Movement.byPosition(this, i);
      } else {
        return null;
      }
    }).toList();
    rayMovements.removeWhere((m) => m == null);
    return rayMovements;
  }

  bool hasElement(List<Movement> movements, TypeTile typeTile) {
    return movements.firstWhere(
            (m) => m != null && getValue(m.getPosition()).typeTile == typeTile,
            orElse: () => null) !=
        null;
  }

  bool allIsFire() {
    return tiles.fold(
        true, (bool acc, TileStatus v) => acc && v.typeTile == TypeTile.FIRE);
  }

  BoardStatus extinguishFire() {
    return copyWith(
        tiles: tiles.map((tile) {
      return tile.copyWith(
          typeTile:
              tile.typeTile == TypeTile.FIRE ? TypeTile.NORMAL : tile.typeTile);
    }).toList());
  }

  BoardStatus brushOnBoard(int color) {
    return copyWith(
        tiles: tiles.map((tile) {
      return tile.copyWith(color: color);
    }).toList());
  }

  BoardStatus blockRay() {
    return copyWith(rayBlocked: true);
  }

  bool isSuccess() {
    return allIs(0) || allIs(1);
  }

  bool allIs(int compare) {
    return tiles.fold(
        true, (bool acc, TileStatus v) => acc && v.color == compare);
  }

  TileStatus getValue(int position) {
    return tiles[position];
  }

  BoardStatus setValue(int position, int value,
      {TypeTile typeTile, bool flicker}) {
    var t = tiles;
    t[position] = t[position].copyWith(color: value);
    if (typeTile != null)
      t[position] = t[position].copyWith(typeTile: typeTile);
    if (flicker != null) t[position] = t[position].copyWith(flicker: flicker);
    return copyWith(tiles: t);
  }

  @override
  String toString() {
    return 'BoardStatus{columns: $columns, rows: $rows, allMoves: $allMoves, moves: $moves, tiles: $tiles, typeBoard: $typeBoard, typeLevel: $typeLevel, blocked: $blocked, typeTile: $typeTile, difficulty: $difficulty, assistance: $assistance}';
  }

  void printBoard() {
    if (tiles.length >= 9) {
      print("-------------");
      print("| ${tiles[0].color} | ${tiles[1].color} | ${tiles[2].color} |");
      print("| ${tiles[3].color} | ${tiles[4].color} | ${tiles[5].color} |");
      print("| ${tiles[6].color} | ${tiles[7].color} | ${tiles[8].color} |");
      print("-------------");
    } else {
      print("Only ${tiles.length} tiles");
    }
  }
}

class TileStatus extends Equatable {
  final int color;

  final TypeTile typeTile;

  final bool flicker;

  TileStatus(
      {@required this.color,
      this.typeTile: TypeTile.NORMAL,
      this.flicker = false})
      : super([color, typeTile, flicker]);

  TileStatus copyWith({color, typeTile, flicker}) {
    return TileStatus(
      color: color ?? this.color,
      typeTile: typeTile ?? this.typeTile,
      flicker: flicker ?? this.flicker,
    );
  }

  @override
  String toString() {
    return 'TileStatus{color: $color, typeTile: $typeTile, flicker: $flicker}';
  }
}

class AssistanceStatus extends Equatable {
  final AssistanceItemStatus fireman;
  final AssistanceItemStatus ray;
  final AssistanceItemStatus brush;
  final AssistanceItemStatus block;

  AssistanceStatus({
    this.fireman,
    this.ray,
    this.brush,
    this.block,
  }) : super([fireman, ray, brush, block]);

  @override
  String toString() {
    return 'AssistanceStatus{fireman: $fireman, ray: $ray, brush: $brush, block: $block}';
  }

  AssistanceStatus copyWith({fireman, ray, brush, block}) {
    return AssistanceStatus(
      fireman: fireman ?? this.fireman,
      ray: ray ?? this.ray,
      brush: brush ?? this.brush,
      block: block ?? this.block,
    );
  }

  Map<String, Object> toJson() {
    return {"fireman": fireman, "ray": ray, "brush": brush, "block": block};
  }

  factory AssistanceStatus.fromJson(Map<String, dynamic> parsedJson) {
    var fireman = parsedJson['fireman'];
    var ray = parsedJson['ray'];
    var brush = parsedJson['brush'];
    var block = parsedJson['block'];
    return AssistanceStatus(
      fireman: fireman != null ? AssistanceItemStatus.fromJson(fireman) : null,
      ray: ray != null ? AssistanceItemStatus.fromJson(ray) : null,
      brush: brush != null ? AssistanceItemStatus.fromJson(brush) : null,
      block: block != null ? AssistanceItemStatus.fromJson(block) : null,
    );
  }

  factory AssistanceStatus.fromEntity(AssistanceEntity entity) {
    return AssistanceStatus(
      fireman: entity.fireman != null
          ? AssistanceItemStatus.fromEntity(entity.fireman)
          : null,
      ray: entity.ray != null
          ? AssistanceItemStatus.fromEntity(entity.ray)
          : null,
      brush: entity.brush != null
          ? AssistanceItemStatus.fromEntity(entity.brush)
          : null,
      block: entity.block != null
          ? AssistanceItemStatus.fromEntity(entity.block)
          : null,
    );
  }
}

class AssistanceItemStatus extends Equatable {
  final int afterMoves;

  final int uses;

  AssistanceItemStatus({
    @required this.afterMoves,
    this.uses,
  }) : super([afterMoves, uses]);

  AssistanceItemStatus copyWith({afterMoves, uses}) {
    return AssistanceItemStatus(
      afterMoves: afterMoves ?? this.afterMoves,
      uses: uses ?? this.uses,
    );
  }

  @override
  String toString() {
    return 'AssistanceItemStatus{afterMoves: $afterMoves, uses: $uses}';
  }

  Map<String, Object> toJson() {
    return {"afterMoves": afterMoves, "uses": uses};
  }

  factory AssistanceItemStatus.fromJson(Map<String, dynamic> parsedJson) {
    return AssistanceItemStatus(
      afterMoves: parsedJson['afterMoves'],
      uses: parsedJson['uses'],
    );
  }

  factory AssistanceItemStatus.fromEntity(AssistanceItemEntity entity) {
    return AssistanceItemStatus(
      afterMoves: entity.afterMoves,
    );
  }
}
