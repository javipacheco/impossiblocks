import 'package:impossiblocks/reducers/board_reducer.dart';
import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final boardPlayerOneStateReducer = combineReducers<BoardStatus>([
  TypedReducer<BoardStatus, ChangeColorTileAction>(_changeColorTile),
  TypedReducer<BoardStatus, RandomBoardAction>(_randomBoard),
  TypedReducer<BoardStatus, ResetMovesAction>(_resetMoves),
  TypedReducer<BoardStatus, ResetAllMovesAction>(_resetAllMoves),
  TypedReducer<BoardStatus, BlockTilesAction>(_blockTiles),
  TypedReducer<BoardStatus, UnblockTileAction>(_unblockTile),
  TypedReducer<BoardStatus, LoadLevelInBoardAction>(_loadLevelInBoard),
  TypedReducer<BoardStatus, LoadClassicInBoardAction>(_loadClassicInBoard),
  TypedReducer<BoardStatus, LoadArcadeInBoardAction>(_loadArcadeInBoard),
  TypedReducer<BoardStatus, ChangeTilesInBoardAction>(_changeTilesInBoard),
  TypedReducer<BoardStatus, BlockBoardAction>(_blockBoard),
  TypedReducer<BoardStatus, UnblockBoardAction>(_unblockBoard),
  TypedReducer<BoardStatus, ExtinguishFireAction>(_extinguishFire),
  TypedReducer<BoardStatus, BrushOnBoardAction>(_brushOnBoard),
  TypedReducer<BoardStatus, LoadAssistanceAction>(_loadAssistance),
  TypedReducer<BoardStatus, BlockRayAction>(_blockRay),
  TypedReducer<BoardStatus, ActivateFlickerAction>(_activateFlicker),
  TypedReducer<BoardStatus, DeactivateFlickerAction>(_deactivateFlicker),
  TypedReducer<BoardStatus, AssitanceItemUsedAction>(_assitanceItemUsed),
]);

BoardStatus _changeTilesInBoard(
    BoardStatus board, ChangeTilesInBoardAction action) {
  return changeTilesInBoard(PlayersGame.ONE, board, action);
}

BoardStatus _changeColorTile(BoardStatus board, ChangeColorTileAction action) {
  return changeColorTile(PlayersGame.ONE, board, action);
}

BoardStatus _randomBoard(BoardStatus board, RandomBoardAction action) {
  return randomBoard(PlayersGame.ONE, board, action);
}

BoardStatus _blockTiles(BoardStatus board, BlockTilesAction action) {
  return blockTiles(PlayersGame.ONE, board, action);
}

BoardStatus _unblockTile(BoardStatus board, UnblockTileAction action) {
  return unblockTile(PlayersGame.ONE, board, action);
}

BoardStatus _resetMoves(BoardStatus board, ResetMovesAction action) {
  return resetMoves(PlayersGame.ONE, board, action);
}

BoardStatus _resetAllMoves(BoardStatus board, ResetAllMovesAction action) {
  return resetAllMoves(PlayersGame.ONE, board, action);
}

BoardStatus _loadLevelInBoard(
    BoardStatus board, LoadLevelInBoardAction action) {
  return loadLevelInBoard(PlayersGame.ONE, board, action);
}

BoardStatus _loadClassicInBoard(
    BoardStatus board, LoadClassicInBoardAction action) {
  return loadClassicInBoard(PlayersGame.ONE, board, action);
}

BoardStatus _loadArcadeInBoard(
    BoardStatus board, LoadArcadeInBoardAction action) {
  return loadArcadeInBoard(PlayersGame.ONE, board, action);
}

BoardStatus _blockBoard(BoardStatus board, BlockBoardAction action) {
  return blockBoard(PlayersGame.ONE, board, action);
}

BoardStatus _unblockBoard(BoardStatus board, UnblockBoardAction action) {
  return unblockBoard(PlayersGame.ONE, board, action);
}

BoardStatus _extinguishFire(BoardStatus board, ExtinguishFireAction action) {
  return extinguishFire(PlayersGame.ONE, board, action);
}

BoardStatus _brushOnBoard(BoardStatus board, BrushOnBoardAction action) {
  return brushOnBoard(PlayersGame.ONE, board, action);
}

BoardStatus _loadAssistance(BoardStatus board, LoadAssistanceAction action) {
  return board.copyWith(
      assistance: AssistanceStatus(
    brush: action.brush != null
        ? AssistanceItemStatus(
            afterMoves: action.brush.afterMoves, uses: action.brush.uses)
        : null,
    fireman: action.fireman != null
        ? AssistanceItemStatus(
            afterMoves: action.fireman.afterMoves, uses: action.fireman.uses)
        : null,
    ray: action.ray != null
        ? AssistanceItemStatus(
            afterMoves: action.ray.afterMoves, uses: action.ray.uses)
        : null,
    block: action.block != null
        ? AssistanceItemStatus(
            afterMoves: action.block.afterMoves, uses: action.block.uses)
        : null,
  ));
}

BoardStatus _blockRay(BoardStatus board, BlockRayAction action) {
  return blockRay(PlayersGame.ONE, board, action);
}

BoardStatus _activateFlicker(BoardStatus board, ActivateFlickerAction action) {
  return activateFlicker(PlayersGame.ONE, board, action);
}

BoardStatus _deactivateFlicker(
    BoardStatus board, DeactivateFlickerAction action) {
  return deactivateFlicker(PlayersGame.ONE, board, action);
}

BoardStatus _assitanceItemUsed(
    BoardStatus board, AssitanceItemUsedAction action) {
  return assitanceItemUsed(PlayersGame.ONE, board, action);
}
