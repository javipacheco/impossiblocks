import 'package:impossiblocks/reducers/board_reducer.dart';
import 'package:redux/redux.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:impossiblocks/models/models.dart';

final boardPlayerTwoStateReducer = combineReducers<BoardStatus>([
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
  TypedReducer<BoardStatus, BlockRayAction>(_blockRay),
  TypedReducer<BoardStatus, ActivateFlickerAction>(_activateFlicker),
  TypedReducer<BoardStatus, DeactivateFlickerAction>(_deactivateFlicker),
  TypedReducer<BoardStatus, AssitanceItemUsedAction>(_assitanceItemUsed),
]);

BoardStatus _changeTilesInBoard(
    BoardStatus board, ChangeTilesInBoardAction action) {
  return changeTilesInBoard(PlayersGame.TWO, board, action);
}

BoardStatus _changeColorTile(BoardStatus board, ChangeColorTileAction action) {
  return changeColorTile(PlayersGame.TWO, board, action);
}

BoardStatus _randomBoard(BoardStatus board, RandomBoardAction action) {
  return randomBoard(PlayersGame.TWO, board, action);
}

BoardStatus _blockTiles(BoardStatus board, BlockTilesAction action) {
  return blockTiles(PlayersGame.TWO, board, action);
}

BoardStatus _unblockTile(BoardStatus board, UnblockTileAction action) {
  return unblockTile(PlayersGame.TWO, board, action);
}

BoardStatus _resetMoves(BoardStatus board, ResetMovesAction action) {
  return resetMoves(PlayersGame.TWO, board, action);
}

BoardStatus _resetAllMoves(BoardStatus board, ResetAllMovesAction action) {
  return resetAllMoves(PlayersGame.TWO, board, action);
}

BoardStatus _loadLevelInBoard(
    BoardStatus board, LoadLevelInBoardAction action) {
  return loadLevelInBoard(PlayersGame.TWO, board, action);
}

BoardStatus _loadClassicInBoard(
    BoardStatus board, LoadClassicInBoardAction action) {
  return loadClassicInBoard(PlayersGame.TWO, board, action);
}

BoardStatus _loadArcadeInBoard(
    BoardStatus board, LoadArcadeInBoardAction action) {
  return loadArcadeInBoard(PlayersGame.TWO, board, action);
}

BoardStatus _blockBoard(BoardStatus board, BlockBoardAction action) {
  return blockBoard(PlayersGame.TWO, board, action);
}

BoardStatus _unblockBoard(BoardStatus board, UnblockBoardAction action) {
  return unblockBoard(PlayersGame.TWO, board, action);
}

BoardStatus _extinguishFire(BoardStatus board, ExtinguishFireAction action) {
  return extinguishFire(PlayersGame.TWO, board, action);
}

BoardStatus _brushOnBoard(BoardStatus board, BrushOnBoardAction action) {
  return brushOnBoard(PlayersGame.TWO, board, action);
}

BoardStatus _blockRay(BoardStatus board, BlockRayAction action) {
  return blockRay(PlayersGame.TWO, board, action);
}

BoardStatus _activateFlicker(BoardStatus board, ActivateFlickerAction action) {
  return activateFlicker(PlayersGame.TWO, board, action);
}

BoardStatus _deactivateFlicker(
    BoardStatus board, DeactivateFlickerAction action) {
  return deactivateFlicker(PlayersGame.TWO, board, action);
}

BoardStatus _assitanceItemUsed(
    BoardStatus board, AssitanceItemUsedAction action) {
  return assitanceItemUsed(PlayersGame.TWO, board, action);
}