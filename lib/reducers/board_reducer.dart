import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

BoardStatus changeTilesInBoard(PlayersGame playerGame, BoardStatus board,
    ChangeTilesInBoardAction action) {
  return action.playersGame == playerGame
      ? board.changeTiles(action.tiles)
      : board;
}

BoardStatus changeColorTile(
    PlayersGame playerGame, BoardStatus board, ChangeColorTileAction action) {
  return action.playersGame == playerGame
      ? board.addMovement(action.movement)
      : board;
}

BoardStatus randomBoard(
    PlayersGame playerGame, BoardStatus board, RandomBoardAction action) {
  if (action.playersGame == playerGame) {
    var b = action.typeTile != null && action.difficulty != null
        ? board.copyWith(
            typeTile: action.typeTile, difficulty: action.difficulty)
        : board;
    return b.copyWith(rayBlocked: false).random();
  } else
    return board;
}

BoardStatus blockTiles(
    PlayersGame playerGame, BoardStatus board, BlockTilesAction action) {
  return action.playersGame == playerGame
      ? board.blockTiles(action.items)
      : board;
}

BoardStatus unblockTile(
    PlayersGame playerGame, BoardStatus board, UnblockTileAction action) {
  return action.playersGame == playerGame
      ? board.unblockTile(action.position)
      : board;
}

BoardStatus resetMoves(
    PlayersGame playerGame, BoardStatus board, ResetMovesAction action) {
  return action.playersGame == playerGame ? board.resetMoves() : board;
}

BoardStatus resetAllMoves(
    PlayersGame playerGame, BoardStatus board, ResetAllMovesAction action) {
  return action.playersGame == playerGame ? board.resetAllMoves() : board;
}

BoardStatus loadLevelInBoard(
    PlayersGame playerGame, BoardStatus board, LoadLevelInBoardAction action) {
  if (action.playersGame == playerGame) {
    var board = BoardStatus(
        rows: action.level.rows,
        columns: action.level.columns,
        allMoves: 0,
        moves: 0,
        tiles: action.level.board != null
            ? action.level.board.map((c) => TileStatus(color: c)).toList()
            : List(),
        typeBoard: TypeBoardGame.LEVEL,
        typeLevel: action.level.levelType == "color-counter"
            ? TypeBoardLevel.COLOR_COUNTER
            : TypeBoardLevel.MOVEMENT_COUNTER,
        blocked: false,
        typeTile: action.typeTile,
        difficulty: action.difficulty,
        assistance: action.level.assistance != null
            ? AssistanceStatus.fromEntity(action.level.assistance)
            : null);
    return action.level.board != null ? board : board.random();
  } else {
    return board;
  }
}

BoardStatus loadClassicInBoard(PlayersGame playerGame, BoardStatus board,
    LoadClassicInBoardAction action) {
  return action.playersGame == playerGame
      ? BoardStatus.random(action.sizeBoardGame).copyWith(
          moves: 0,
          typeBoard: TypeBoardGame.CLASSIC,
        )
      : board;
}

BoardStatus loadArcadeInBoard(
    PlayersGame playerGame, BoardStatus board, LoadArcadeInBoardAction action) {
  return action.playersGame == playerGame
      ? BoardStatus.random(action.sizeBoardGame).copyWith(
          moves: 0,
          typeBoard: TypeBoardGame.ARCADE,
        )
      : board;
}

BoardStatus blockBoard(
    PlayersGame playerGame, BoardStatus board, BlockBoardAction action) {
  return action.playersGame == playerGame ? board.block() : board;
}

BoardStatus unblockBoard(
    PlayersGame playerGame, BoardStatus board, UnblockBoardAction action) {
  return action.playersGame == playerGame ? board.unblock() : board;
}

BoardStatus extinguishFire(
    PlayersGame playerGame, BoardStatus board, ExtinguishFireAction action) {
  return action.playersGame == playerGame ? board.extinguishFire() : board;
}

BoardStatus brushOnBoard(
    PlayersGame playerGame, BoardStatus board, BrushOnBoardAction action) {
  return action.playersGame == playerGame
      ? board.brushOnBoard(action.color)
      : board;
}

BoardStatus blockRay(
    PlayersGame playerGame, BoardStatus board, BlockRayAction action) {
  return action.playersGame == playerGame ? board.blockRay() : board;
}

BoardStatus activateFlicker(
    PlayersGame playerGame, BoardStatus board, ActivateFlickerAction action) {
  return action.playersGame == playerGame
      ? board.addFlicker(action.position)
      : board;
}

BoardStatus deactivateFlicker(
    PlayersGame playerGame, BoardStatus board, DeactivateFlickerAction action) {
  return action.playersGame == playerGame
      ? board.removeFlicker(action.position)
      : board;
}

BoardStatus assitanceItemUsed(
    PlayersGame playerGame, BoardStatus board, AssitanceItemUsedAction action) {
  return action.playersGame == playerGame
      ? board.assistanceUsed(action.assistanceActionType)
      : board;
}
