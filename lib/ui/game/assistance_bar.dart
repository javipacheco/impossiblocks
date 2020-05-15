import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/game/viewmodels/board_view_model.dart';
import 'package:impossiblocks/ui/widgets/circle_progress_background.dart';
import 'package:impossiblocks/utils/game_utils.dart';
import 'package:badges/badges.dart';

class AssistanceBar extends StatefulWidget {
  final SizeScreen sizeScreen;

  final PlayersGame playersGame;

  AssistanceBar({Key key, @required this.sizeScreen, @required this.playersGame}) : super(key: key);

  _AssistanceBarState createState() => _AssistanceBarState();
}

class _AssistanceBarState extends State<AssistanceBar> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BoardViewModel>(
        distinct: true,
        converter: (store) => BoardViewModel.build(store, widget.playersGame),
        builder: (context, viewModel) {
          double size = AssistanceCommons.siseAction(widget.sizeScreen);
          double padding = AssistanceCommons.padding(widget.sizeScreen);
          return Container(
            constraints: BoxConstraints.expand(
                height: size + padding, width: size * 6 + padding * 4),
            decoration:
                AssistanceCommons.boxDecoration(Colors.grey.withAlpha(160)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                AssistanceAction(
                  sizeScreen: viewModel.sizeScreen,
                  assistanceActionType: AssistanceActionType.BRUSH1,
                  assistanceItemStatus: viewModel.board.assistance?.brush,
                  coins: viewModel.coins,
                  moves: viewModel.board.moves,
                  onTap: (used) {
                    viewModel.onBrusOnBoard(0, used);
                  },
                ),
                AssistanceAction(
                  sizeScreen: viewModel.sizeScreen,
                  assistanceActionType: AssistanceActionType.BRUSH2,
                  assistanceItemStatus: viewModel.board.assistance?.brush,
                  coins: viewModel.coins,
                  moves: viewModel.board.moves,
                  onTap: (used) {
                    viewModel.onBrusOnBoard(1, used);
                  },
                ),
                buildCoins(viewModel.sizeScreen, viewModel.coins),
                AssistanceAction(
                  sizeScreen: viewModel.sizeScreen,
                  assistanceActionType: AssistanceActionType.BLOCK,
                  assistanceItemStatus: viewModel.board.assistance?.block,
                  coins: viewModel.coins,
                  moves: viewModel.board.moves,
                  onTap: (_) {},
                  noCoins: true,
                ),
                AssistanceAction(
                  sizeScreen: viewModel.sizeScreen,
                  assistanceActionType:
                      viewModel.board.assistance?.ray != null
                          ? AssistanceActionType.LIGHTNING
                          : AssistanceActionType.FIREMAN,
                  assistanceItemStatus: viewModel.board.assistance?.fireman ??
                      viewModel.board.assistance?.ray,
                  coins: viewModel.coins,
                  moves: viewModel.board.moves,
                  onTap: (used) {
                    if (viewModel.board.assistance?.fireman != null) {
                      viewModel.onExtinguishFire(used);
                    } else if (viewModel.board.assistance?.ray != null) {
                      viewModel.onBlockLightning(used);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget buildCoins(SizeScreen sizeScreen, int coins) {
    double size = AssistanceCommons.siseAction(widget.sizeScreen);
    return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(height: size, width: size * 2),
        decoration: AssistanceCommons.boxDecoration(Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SvgPicture.asset(
              "assets/images/ic_coins.svg",
              color: ResColors.primaryColor,
              width: Dimensions.getSizeIcon(sizeScreen, 30.0),
              height: Dimensions.getSizeIcon(sizeScreen, 30.0),
            ),
            Text(
              "$coins",
              style: ResStyles.big(sizeScreen, color: ResColors.primaryColor),
            )
          ],
        ));
  }
}

class AssistanceBadge extends StatelessWidget {
  final Widget child;
  final int number;
  final bool showBadge;
  final SizeScreen sizeScreen;
  const AssistanceBadge(
      {Key key,
      @required this.child,
      @required this.number,
      @required this.showBadge,
      @required this.sizeScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      showBadge: showBadge,
      animationType: BadgeAnimationType.scale,
      elevation: 4.0,
      toAnimate: true,
      padding: EdgeInsets.all(4),
      badgeContent: SizedBox(
        width: 14,
        height: 14,
        child: Center(
          child: Text(
            number.toString(),
            style: ResStyles.small(sizeScreen, color: Colors.white),
          ),
        ),
      ),
      child: child,
    );
  }
}

enum AssistanceActionType { BRUSH1, BRUSH2, LIGHTNING, FIREMAN, BLOCK }

enum AssistanceActionStyle { NORMAL, DISABLED, GHOST, NO_COINS }

class AssistanceAction extends StatefulWidget {
  final SizeScreen sizeScreen;

  final AssistanceActionType assistanceActionType;

  final AssistanceItemStatus assistanceItemStatus;

  final int coins;

  final int moves;

  final Function(bool) onTap;

  final bool noCoins;

  AssistanceAction({
    Key key,
    @required this.sizeScreen,
    @required this.assistanceActionType,
    @required this.assistanceItemStatus,
    @required this.coins,
    @required this.moves,
    @required this.onTap,
    this.noCoins = false,
  }) : super(key: key);

  _AssistanceActionState createState() => _AssistanceActionState();
}

class _AssistanceActionState extends State<AssistanceAction> {
  AssistanceActionStyle _getAssistanceActionStyle() {
    if (widget.assistanceItemStatus != null) {
      if (widget.assistanceItemStatus.uses != null &&
          widget.assistanceItemStatus.uses <= 0) {
        return AssistanceActionStyle.DISABLED;
      } else {
        if (widget.coins >= _getCoinsFor() || widget.noCoins) {
          if (widget.assistanceItemStatus.afterMoves - 1 < widget.moves)
            return AssistanceActionStyle.NORMAL;
          else
            return AssistanceActionStyle.GHOST;
        } else
          return AssistanceActionStyle.NO_COINS;
      }
    } else
      return AssistanceActionStyle.DISABLED;
  }

  int _getCoinsFor() {
    switch (widget.assistanceActionType) {
      case AssistanceActionType.FIREMAN:
        return GameUtils.coinsForFireman;
        break;
      case AssistanceActionType.LIGHTNING:
        return GameUtils.coinsForRay;
        break;
      case AssistanceActionType.BLOCK:
        return GameUtils.coinsForBlock;
        break;
      default:
        return GameUtils.coinsForBrush;
        break;
    }
  }

  String _getImage(AssistanceActionStyle style) {
    if (style != AssistanceActionStyle.NO_COINS) {
      switch (widget.assistanceActionType) {
        case AssistanceActionType.FIREMAN:
          return "assets/images/ic_fireman.svg";
          break;
        case AssistanceActionType.LIGHTNING:
          return "assets/images/ic_lighting_rod.svg";
          break;
        case AssistanceActionType.BLOCK:
          return "assets/images/ic_lock.svg";
          break;
        default:
          return "assets/images/ic_brush.svg";
          break;
      }
    } else {
      switch (widget.assistanceActionType) {
        case AssistanceActionType.BLOCK:
          return "assets/images/ic_lock.svg";
          break;
        default:
          return "assets/images/ic_more_coins.svg";
          break;
      }
    }
  }

  Color _getColor(AssistanceActionStyle style) {
    switch (style) {
      case AssistanceActionStyle.NORMAL:
      case AssistanceActionStyle.GHOST:
        int alpha = style == AssistanceActionStyle.NORMAL ? 255 : 160;
        switch (widget.assistanceActionType) {
          case AssistanceActionType.BRUSH1:
            return ResColors.colorTile1.withAlpha(alpha);
            break;
          case AssistanceActionType.BRUSH2:
            return ResColors.colorTile2.withAlpha(alpha);
            break;
          default:
            return Colors.redAccent.withAlpha(alpha);
            break;
        }
        break;
      default:
        return Colors.grey;
        break;
    }
  }

  int _getPercentage(AssistanceActionStyle style) {
    switch (style) {
      case AssistanceActionStyle.GHOST:
        return widget.moves * 100 ~/ widget.assistanceItemStatus.afterMoves;
      default:
        return 100;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    AssistanceActionStyle style = _getAssistanceActionStyle();
    return GestureDetector(
      onTap: () {
        if (style == AssistanceActionStyle.NORMAL) {
          if (widget.assistanceItemStatus.uses == null) {
            widget.onTap(false);
          } else if (widget.assistanceItemStatus.uses != null &&
              widget.assistanceItemStatus.uses > 0) {
            widget.onTap(true);
          }
        }
      },
      child: AssistanceBadge(
        sizeScreen: widget.sizeScreen,
        showBadge: style == AssistanceActionStyle.NORMAL &&
            widget.assistanceItemStatus.uses != null,
        number: widget.assistanceItemStatus?.uses ?? 0,
        child: CircleProgressBackground(
            colorBack: Colors.grey,
            colorFront: _getColor(style),
            percentage: _getPercentage(style),
            size: AssistanceCommons.siseAction(widget.sizeScreen),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                _getImage(style),
                color: Colors.white70,
              ),
            )),
      ),
    );
  }
}

class AssistanceCommons {
  static double siseAction(SizeScreen sizeScreen) =>
      Dimensions.getSizeIcon(sizeScreen, 48);
  static double padding(SizeScreen sizeScreen) =>
      Dimensions.getSizePadding(sizeScreen, 10);
  static BoxDecoration boxDecoration(Color color) {
    return BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
        borderRadius: BorderRadius.circular(Dimensions.roundedLayout));
  }
}
