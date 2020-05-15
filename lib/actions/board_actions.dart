import 'package:impossiblocks/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';

class ChangeColorTileAction {
  final PlayersGame playersGame;

  final Movement movement;

  ChangeColorTileAction({@required this.playersGame, @required this.movement});

  @override
  String toString() {
    return 'ChangeColorTileAction{playersGame: $playersGame, movement: $movement}';
  }
}

class ChangeTilesInBoardAction {
  final PlayersGame playersGame;

  final List<TileStatus> tiles;

  ChangeTilesInBoardAction({@required this.playersGame, @required this.tiles});

  @override
  String toString() {
    return 'ChangeTilesInBoardAction{playersGame: $playersGame, tiles: $tiles}';
  }
}

class BlockTilesAction {
  final PlayersGame playersGame;
  
  final List<int> items;

  BlockTilesAction({@required this.playersGame, @required this.items});

  @override
  String toString() {
    return 'BlockTilesAction{playersGame: $playersGame, items: $items}';
  }
}

class UnblockTileAction {
  final PlayersGame playersGame;

  final int position;

  UnblockTileAction({@required this.playersGame, @required this.position});

  @override
  String toString() {
    return 'UnblockTileAction{playersGame: $playersGame, items: $position}';
  }
}

class ResetMovesAction {
  final PlayersGame playersGame;

  ResetMovesAction({@required this.playersGame});

  @override
  String toString() {
    return 'ResetMovesAction{playersGame: $playersGame}';
  }
}

class ResetAllMovesAction {
  final PlayersGame playersGame;

  ResetAllMovesAction({@required this.playersGame});

  @override
  String toString() {
    return 'ResetAllMovesAction{playersGame: $playersGame}';
  }
}

/*
Crea un nuevo tablero de manera aleatoria, con dificultad y elementos en el caso que se añadan
*/
class RandomBoardAction {
  final PlayersGame playersGame;

  final TypeTile typeTile;

  final int difficulty;

  RandomBoardAction({@required this.playersGame, this.typeTile, this.difficulty});

  @override
  String toString() {
    return 'RandomBoardAction{playersGame: $playersGame, typeTile : $typeTile, difficulty: $difficulty}';
  }
}

class LoadLevelInBoardAction {
  final PlayersGame playersGame;

  final LevelEntity level;

  final TypeTile typeTile;

  final int difficulty;

  LoadLevelInBoardAction(
      {@required this.playersGame, @required this.level,
      this.typeTile = TypeTile.NORMAL,
      this.difficulty = 1});

  @override
  String toString() {
    return 'LoadLevelInBoardAction{playersGame: $playersGame, level : $level, typeTile : $typeTile, difficulty: $difficulty}';
  }
}

class LoadClassicInBoardAction {
  final PlayersGame playersGame;

  final SizeBoardGame sizeBoardGame;

  LoadClassicInBoardAction({@required this.playersGame, @required this.sizeBoardGame});

  @override
  String toString() {
    return 'LoadClassicInBoardAction{playersGame: $playersGame, sizeBoardGame: $sizeBoardGame}';
  }
}

class LoadArcadeInBoardAction {
  final PlayersGame playersGame;

  final SizeBoardGame sizeBoardGame;

  LoadArcadeInBoardAction({@required this.playersGame, @required this.sizeBoardGame});

  @override
  String toString() {
    return 'LoadArcadeInBoardAction{playersGame: $playersGame, sizeBoardGame: $sizeBoardGame}';
  }
}

/*
Bloquea el tablero para que no permita clicks
*/
class BlockBoardAction {
  final PlayersGame playersGame;

  BlockBoardAction({@required this.playersGame});

  @override
  String toString() {
    return 'BlockBoardAction{playersGame: $playersGame}';
  }
}

/*
Desbloquea el tablero
*/
class UnblockBoardAction {
  final PlayersGame playersGame;

  UnblockBoardAction({@required this.playersGame});

  @override
  String toString() {
    return 'UnblockBoardAction{playersGame: $playersGame}';
  }
}

class ExtinguishFireAction {
  final PlayersGame playersGame;

  ExtinguishFireAction({@required this.playersGame});

  @override
  String toString() {
    return 'ExtinguishFireAction{playersGame: $playersGame}';
  }
}

class BrushOnBoardAction {
  final PlayersGame playersGame;

  final int color;

  BrushOnBoardAction({@required this.playersGame, @required this.color});

  @override
  String toString() {
    return 'BrushOnBoardAction{playersGame: $playersGame, color: $color}';
  }
}

class LoadAssistanceAction {
  final AssistanceItemAction fireman;
  final AssistanceItemAction ray;
  final AssistanceItemAction block;
  final AssistanceItemAction brush;

  LoadAssistanceAction({
    @required this.fireman,
    @required this.ray,
    @required this.block,
    @required this.brush,
  });

  @override
  String toString() {
    return 'fireman: $fireman, ray: $ray, brush: $brush, block: $block}';
  }
}

class AssistanceItemAction {

  final int afterMoves;

  final int uses;

  AssistanceItemAction({
    @required this.afterMoves,
    this.uses,
  });

  @override
  String toString() {
    return 'AssistanceItemAction{afterMoves: $afterMoves, uses: $uses}';
  }
}

class BlockRayAction {
  final PlayersGame playersGame;

  BlockRayAction({@required this.playersGame});

  @override
  String toString() {
    return 'BlockRayAction{playersGame: $playersGame}';
  }
}

class ActivateFlickerAction {
  final PlayersGame playersGame;

  final int position;

  ActivateFlickerAction({@required this.playersGame, @required this.position});

  @override
  String toString() {
    return 'ActivateFlickerAction{playersGame: $playersGame, position: $position}';
  }
}

/*
Desactivamos el ficker en el tile dentro del estado para que
no se reproduzca la animación de nuevo
*/
class DeactivateFlickerAction {
  final PlayersGame playersGame;

  final int position;

  DeactivateFlickerAction({@required this.playersGame, @required this.position});

  @override
  String toString() {
    return 'DeactivateFlickerAction{playersGame: $playersGame, position: $position}';
  }
}

/*
Se ha usado un item de la barra de asistencia y hay que quitar
uno uso en el caso que sea necesario
*/
class AssitanceItemUsedAction {
  final PlayersGame playersGame;

  final AssistanceActionType assistanceActionType;

  AssitanceItemUsedAction({@required this.playersGame, @required this.assistanceActionType});

  @override
  String toString() {
    return 'AssitanceItemUsedAction{playersGame: $playersGame, assistanceActionType: $assistanceActionType}';
  }
}
