import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_dimensions.dart';
import 'package:impossiblocks/ui/leadboards/user_leadboard_item.dart';
import 'package:impossiblocks/ui/leadboards/viewmodels/leadboards_local_view_model.dart';
import 'package:impossiblocks/ui/widgets/horizontal_radio_buttons.dart';
import 'package:impossiblocks/ui/widgets/rounded_container.dart';

class LeadboardsLocalContainer extends StatefulWidget {
  final TypeBoardGame typeBoardGame;

  LeadboardsLocalContainer({Key key, @required this.typeBoardGame})
      : super(key: key);

  _LeadboardsLocalContainerState createState() =>
      _LeadboardsLocalContainerState();
}

class _LeadboardsLocalContainerState extends State<LeadboardsLocalContainer> {
  List<String> _items = ["3x3", "4x4", "5x5"];

  List _gamesArcade = [
    LeadboardGames.X3_3_ARCADE,
    LeadboardGames.X4_4_ARCADE,
    LeadboardGames.X5_5_ARCADE,
  ];

  List _gamesClassic = [
    LeadboardGames.X3_3_CLASSIC,
    LeadboardGames.X4_4_CLASSIC,
    LeadboardGames.X5_5_CLASSIC,
  ];

  int _typeGame;

  bool reloadUsers = false;

  @override
  void initState() {
    _typeGame = 0;
    super.initState();
  }

  void _reloadUsers(LeadboardsLocalViewModel viewModel) {
    viewModel.onLoadUsers(widget.typeBoardGame == TypeBoardGame.ARCADE
        ? _gamesArcade[_typeGame]
        : _gamesClassic[_typeGame]);
  }

  @override
  void didUpdateWidget(LeadboardsLocalContainer oldWidget) {
    if (oldWidget.typeBoardGame != widget.typeBoardGame) {
      reloadUsers = true;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LeadboardsLocalViewModel>(
        distinct: true,
        converter: (store) => LeadboardsLocalViewModel.build(store),
        onInitialBuild: (viewModel) {
          _reloadUsers(viewModel);
        },
        builder: (context, viewModel) {
          if (reloadUsers) {
            reloadUsers = false;
            _reloadUsers(viewModel);
          }
          return RoundedContainer(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  RoundedContainer(
                    color: ResColors.colorTile1,
                    child: HorizontalRadioButtons(
                      sizeScreen: viewModel.sizeScreen,
                      selectedColor: Colors.white,
                      normalColor: ResColors.colorTile1,
                      items: _items,
                      itemSelected: _items[_typeGame],
                      onTap: (position) {
                        setState(() {
                          _typeGame = position;
                          _reloadUsers(viewModel);
                        });
                      },
                    ),
                    padding: EdgeInsets.only(top: 12),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Dimensions.leadboardsHeightContainer),
                    child: RoundedContainer(
                      color: Colors.white,
                      bgColor: ResColors.colorTile1,
                      child: UserLeadboardItem(sizeScreen: viewModel.sizeScreen ,users: viewModel.users),
                    ),
                  ),
                ],
              ));
        });
  }
}
