import 'dart:async';
import 'package:impossiblocks/controller/sound_controller.dart';
import 'package:impossiblocks/modules/modules.dart';
import 'package:impossiblocks/ui/game/assistance_bar.dart';
import 'package:impossiblocks/ui/widgets/swipe_detector.dart';
import 'package:impossiblocks/utils/debug_utils.dart';
import 'package:impossiblocks/utils/game_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/actions/actions.dart';
import 'package:flutter/widgets.dart';
import "package:equatable/equatable.dart";

class BoardViewModel extends Equatable {
  final SizeScreen sizeScreen;

  final GameViewStatus gameViewStatus;

  final bool Function(GameStatus) isGameStatus;

  final int columns;

  final int rows;

  final BoardStatus board;

  final int coins;

  final bool userRemoveAnimations;

  final Function(bool) onExtinguishFire;

  final Function(int, bool) onBrusOnBoard;

  final Function(bool) onBlockLightning;

  final Function() onSwipeTiles;

  final Function(List<int>) onBlockTiles;

  final Function(Movement) onClickTile;

  final Function(Movement) onLongClickTile;

  final Function(int) onDeactivateFlicker;

  final Function(SwipeMove) onUpdateTilesAfterSwipe;

  BoardViewModel({
    @required this.sizeScreen,
    @required this.gameViewStatus,
    @required this.isGameStatus,
    @required this.columns,
    @required this.rows,
    @required this.board,
    @required this.coins,
    @required this.userRemoveAnimations,
    @required this.onExtinguishFire,
    @required this.onBrusOnBoard,
    @required this.onBlockLightning,
    @required this.onSwipeTiles,
    @required this.onBlockTiles,
    @required this.onClickTile,
    @required this.onLongClickTile,
    @required this.onDeactivateFlicker,
    @required this.onUpdateTilesAfterSwipe,
  }) : super([
          sizeScreen,
          board,
          gameViewStatus,
          columns,
          rows,
          coins,
          userRemoveAnimations
        ]);

  static build(Store<AppState> store, PlayersGame playersGame) {
    UserModule userModule = new UserModule();

    BoardStatus getBoard() => playersGame == PlayersGame.ONE
        ? store.state.board
        : store.state.boardPlayerTwo;

    var gameSuccess = GameSuccess(
      store: store,
      addCoins: (c) async {
        await userModule.repositoryService
            .addCoinsToUser(store.state.users.current.id, c);
        UserRepository user = await userModule.getCurrentUser();
        var userState = UserState.fromRepository(user);
        store.dispatch(LoadCurrentUserAction(user: userState));
      },
      playersGame: playersGame,
    );

    void checkSuccess() {
      if (getBoard().allIsFire()) {
        SoundController.instance
            .play(SoundEffect.FAILED, store.state.preferences.soundVolume, 1.0);
        gameSuccess.fire();
      } else if (getBoard().isSuccess()) {
        SoundController.instance.play(
            SoundEffect.SUCCESS, store.state.preferences.soundVolume, 1.0);
        gameSuccess.success();
      }
    }

    Future<UserState> dispatchCurrentUser() {
      return userModule.getCurrentUser().then((user) {
        var userState = UserState.fromRepository(user);
        store.dispatch(LoadCurrentUserAction(user: userState));
        return userState;
      });
    }

    void spendCoins(AssistanceActionType assistanceActionType) async {
      switch (getBoard().typeBoard) {
        case TypeBoardGame.LEVEL:
          store.dispatch(SpendCoinsLevelAction(
              assistanceActionType: assistanceActionType));
          break;
        case TypeBoardGame.ARCADE:
          await userModule.repositoryService.addCoinsToUser(
              store.state.users.current.id,
              -GameUtils.getCoinsFor(assistanceActionType));
          dispatchCurrentUser();
          break;
        default:
          break;
      }
    }

    void soundClick(BoardStatus board, Movement movement) {
      if (store.state.preferences.soundVolume > 0) {
        Movement up = movement.getMovement(Position.UP);
        Movement down = movement.getMovement(Position.DOWN);
        Movement left = movement.getMovement(Position.LEFT);
        Movement right = movement.getMovement(Position.RIGHT);
        List<Movement> movements = [movement, up, down, left, right];
        bool hasLightning = !board.lightningBlocked &&
            board.hasElement(movements, TypeTile.LIGHTNING);
        if (hasLightning) {
          SoundController.instance.play(
              SoundEffect.LIGHTNING, store.state.preferences.soundVolume, 1.0);
        } else {
          bool hasFire = board.hasElement(movements, TypeTile.FIRE);
          if (hasFire) {
            SoundController.instance.play(
                SoundEffect.FIRE, store.state.preferences.soundVolume, 1.0);
          } else {
            SoundController.instance.play(
                SoundEffect.SWIPE, store.state.preferences.soundVolume, 1.0);
          }
        }
      }
    }

    DebugUtils.debugPrint("BoardViewModel => build: ${DateTime.now()}");
    return BoardViewModel(
        sizeScreen: store.state.preferences.sizeScreen,
        gameViewStatus: store.state.gameViewStatus,
        columns: getBoard().columns,
        rows: getBoard().rows,
        isGameStatus: (status) => store.state.gameViewStatus.status == status,
        board: getBoard(),
        coins: getBoard().typeBoard == TypeBoardGame.LEVEL
            ? store.state.levels.coins
            : store.state.users.current.coins,
        userRemoveAnimations: store.state.preferences.userRemoveAnims,
        onExtinguishFire: (used) async {
          if (used)
            store.dispatch(AssitanceItemUsedAction(
                playersGame: playersGame,
                assistanceActionType: AssistanceActionType.FIREMAN));
          SoundController.instance
              .play(SoundEffect.FIRE, store.state.preferences.soundVolume, 1.0);
          store.dispatch(ExtinguishFireAction(
            playersGame: playersGame,
          ));
          spendCoins(AssistanceActionType.FIREMAN);
        },
        onBlockLightning: (used) async {
          if (used)
            store.dispatch(AssitanceItemUsedAction(
                playersGame: playersGame,
                assistanceActionType: AssistanceActionType.LIGHTNING));
          SoundController.instance.play(
              SoundEffect.LIGHTNING, store.state.preferences.soundVolume, 1.0);
          store.dispatch(BlockRayAction(
            playersGame: playersGame,
          ));
          spendCoins(AssistanceActionType.LIGHTNING);
        },
        onBrusOnBoard: (color, used) async {
          if (used)
            store.dispatch(AssitanceItemUsedAction(
                playersGame: playersGame,
                assistanceActionType: AssistanceActionType.BRUSH1));
          AssistanceActionType assistanceActionType = color == 0
              ? AssistanceActionType.BRUSH1
              : AssistanceActionType.BRUSH2;
          store.dispatch(
              BrushOnBoardAction(playersGame: playersGame, color: color));
          spendCoins(assistanceActionType);
          checkSuccess();
        },
        onSwipeTiles: () {
          SoundController.instance.play(
              SoundEffect.SWIPE, store.state.preferences.soundVolume, 1.0);
        },
        onBlockTiles: (tiles) {
          SoundController.instance
              .play(SoundEffect.LOCK, store.state.preferences.soundVolume, 1.0);
          bool isBlocked =
              getBoard().isAssistanceCompleted(AssistanceActionType.BLOCK);
          if (isBlocked ||
              GameUtils.getUserCoins(store.state) >= GameUtils.coinsForBlock) {
            if (!isBlocked) {
              // No es gratis
              spendCoins(AssistanceActionType.BLOCK);
            }
            store.dispatch(
                BlockTilesAction(playersGame: playersGame, items: tiles));
          } else {
            tiles.forEach((tile) {
              store.dispatch(ActivateFlickerAction(
                  playersGame: playersGame, position: tile));
            });
          }
        },
        onClickTile: (Movement movement) {
          if (!getBoard().blocked &&
              store.state.gameViewStatus.status == GameStatus.PLAYING) {
            soundClick(getBoard(), movement);
            store.dispatch(ChangeColorTileAction(
                playersGame: playersGame, movement: movement));
            checkSuccess();
          }
        },
        onLongClickTile: (Movement movement) {
          if (!getBoard().blocked &&
              getBoard().isTileBlocked(movement.getPosition()) &&
              store.state.gameViewStatus.status == GameStatus.PLAYING) {
            SoundController.instance.play(
                SoundEffect.LOCK, store.state.preferences.soundVolume, 1.0);
            store.dispatch(UnblockTileAction(
                playersGame: playersGame,
                position:
                    (movement.row * movement.board.columns + movement.column)));
          }
        },
        onDeactivateFlicker: (position) {
          store.dispatch(DeactivateFlickerAction(
              playersGame: playersGame, position: position));
        },
        onUpdateTilesAfterSwipe: (swipeMove) {
          List<TileStatus> updateTiles() {
            BoardStatus board = getBoard();
            if (swipeMove.move == Move.UP) {
              return List.generate(board.columns * board.rows, (i) {
                Movement movement = Movement.byPosition(board, i);
                if (swipeMove.shouldMove(movement)) {
                  int translate = i + board.columns;
                  return translate < board.columns * board.rows
                      ? board.tiles[translate]
                      : board.tiles[swipeMove.column];
                } else {
                  return board.tiles[i];
                }
              });
            } else if (swipeMove.move == Move.DOWN) {
              return List.generate(board.columns * board.rows, (i) {
                Movement movement = Movement.byPosition(board, i);
                if (swipeMove.shouldMove(movement)) {
                  int translate = i - board.columns;
                  return translate >= 0
                      ? board.tiles[translate]
                      : board.tiles[(board.columns * (board.rows - 1)) +
                          swipeMove.column];
                } else {
                  return board.tiles[i];
                }
              });
            } else if (swipeMove.move == Move.LEFT) {
              return List.generate(board.columns * board.rows, (i) {
                Movement movement = Movement.byPosition(board, i);
                if (swipeMove.shouldMove(movement)) {
                  int translate =
                      i % board.columns != board.columns - 1 ? i + 1 : -1;
                  return translate >= 0
                      ? board.tiles[translate]
                      : board.tiles[board.columns * swipeMove.row];
                } else {
                  return board.tiles[i];
                }
              });
            } else if (swipeMove.move == Move.RIGHT) {
              return List.generate(board.columns * board.rows, (i) {
                Movement movement = Movement.byPosition(board, i);
                if (swipeMove.shouldMove(movement)) {
                  int translate = i % board.columns != 0 ? i - 1 : -1;
                  return translate >= 0
                      ? board.tiles[translate]
                      : board.tiles[(board.columns * (swipeMove.row + 1)) - 1];
                } else {
                  return board.tiles[i];
                }
              });
            }
            return board.tiles;
          }

          store.dispatch(ChangeTilesInBoardAction(
              playersGame: playersGame, tiles: updateTiles()));
          checkSuccess();
        });
  }
}

class GameSuccess {
  final Store<AppState> store;

  final Function(int) addCoins;

  final PlayersGame playersGame;

  BoardStatus _getBoard() => playersGame == PlayersGame.ONE
      ? store.state.board
      : store.state.boardPlayerTwo;

  GameSuccess(
      {@required this.store,
      @required this.addCoins,
      @required this.playersGame});

  void _successLevel() {
    switch (_getBoard().typeLevel) {
      case TypeBoardLevel.COLOR_COUNTER:
        _successColorCounter();
        break;
      case TypeBoardLevel.MOVEMENT_COUNTER:
        _successMovementCounter();
        break;
    }
  }

  void _successColorCounter() {
    store.dispatch(
        SucessScoreColorLevelAction(color: _getBoard().tiles[0].color));
    if (store.state.scoreCounterColorsLevel.isWin()) {
      addCoins(2);
      store.dispatch(ChangeStatusGameAction(status: GameStatus.RESUME));
    } else {
      store.dispatch(ResetMovesAction(
        playersGame: playersGame,
      ));
      store.dispatch(RandomBoardAction(
        playersGame: playersGame,
      ));
    }
  }

  void _successMovementCounter() {
    addCoins(2);
    store.dispatch(ChangeStatusGameAction(status: GameStatus.RESUME));
  }

  void _successArcade() {
    store.dispatch(AddPointToScoreAction(playersGame: playersGame));
    store.dispatch(ResetMovesAction(
      playersGame: playersGame,
    ));
    store.dispatch(
        SucessScoreColorLevelAction(color: _getBoard().tiles[0].color));
    if (store.state.scoreCounterColorsLevel.isWin()) {
      store.dispatch(UpdateScoreForUpgradingLevelAction());
      store.dispatch(UpgradeScoreColorLevelAction());
      store.dispatch(ChangeStatusGameAction(status: GameStatus.CHANGING_LEVEL));
      GameUtils.createArcadeLevel(
          store, store.state.scoreCounterColorsLevel.level);
    } else {
      store.dispatch(RandomBoardAction(
        playersGame: playersGame,
      ));
    }
  }

  void _successClassic() {
    store.dispatch(AddPointToScoreAction(playersGame: playersGame));
    store.dispatch(ResetMovesAction(
      playersGame: playersGame,
    ));
    store.dispatch(RandomBoardAction(
      playersGame: playersGame,
    ));
  }

  void success() {
    store.dispatch(BlockBoardAction(
      playersGame: playersGame,
    ));
    Timer(Duration(milliseconds: 800), () {
      store.dispatch(UnblockBoardAction(
        playersGame: playersGame,
      ));
      switch (_getBoard().typeBoard) {
        case TypeBoardGame.LEVEL:
          _successLevel();
          break;
        case TypeBoardGame.CLASSIC:
          _successClassic();
          break;
        case TypeBoardGame.ARCADE:
          _successArcade();
          break;
      }
    });
  }

  void _fireArcade() {
    store.dispatch(RemovePointToScoreAction(playersGame: playersGame));
    store.dispatch(ResetMovesAction(
      playersGame: playersGame,
    ));
    store.dispatch(RandomBoardAction(
        playersGame: playersGame, typeTile: TypeTile.FIRE, difficulty: 1));
  }

  void _fireColorCounterLevel() {
    store.dispatch(FailedScoreColorLevelAction());
    store.dispatch(RandomBoardAction(
      playersGame: playersGame,
    ));
  }

  void fire() {
    store.dispatch(BlockBoardAction(
      playersGame: playersGame,
    ));
    Timer(Duration(milliseconds: 800), () {
      store.dispatch(UnblockBoardAction(
        playersGame: playersGame,
      ));
      switch (_getBoard().typeBoard) {
        case TypeBoardGame.LEVEL:
          switch (_getBoard().typeLevel) {
            case TypeBoardLevel.COLOR_COUNTER:
              _fireColorCounterLevel();
              break;
            case TypeBoardLevel.MOVEMENT_COUNTER:
              // TODO
              break;
          }
          break;
        case TypeBoardGame.CLASSIC:
          // TODO
          break;
        case TypeBoardGame.ARCADE:
          _fireArcade();
          break;
      }
    });
  }
}
