import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/ui/leadboards/leadboards_local_container.dart';
import 'package:impossiblocks/ui/main/viewmodels/main_screen_view_model.dart';
import 'package:impossiblocks/ui/widgets/title_app_bar.dart';

class LeadboardsScreen extends StatefulWidget {
  LeadboardsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LeadboardsScreenState createState() => _LeadboardsScreenState();
}

class _LeadboardsScreenState extends State<LeadboardsScreen> {
  int _selectedIndex = 0;

  String getTitle() {
    String section = _selectedIndex == 0
        ? ImpossiblocksLocalizations.of(context).text("arcade")
        : _selectedIndex == 1
            ? ImpossiblocksLocalizations.of(context).text("classic")
            : ImpossiblocksLocalizations.of(context).text("levels");
    return "${ImpossiblocksLocalizations.of(context).text("leadboards")} : $section";
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MainScreenViewModel>(
        converter: (store) => MainScreenViewModel.build(store),
        onInitialBuild: (viewModel) {
          viewModel.onLoadUsers();
        },
        builder: (context, viewModel) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: SizedBox.shrink(),
                    onPressed: null,
                  ),
                ],
                title: Center(
                  child: TitleAppBar(title: getTitle()),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/images/ic_arcade.svg",
                      color: Colors.black54,
                      width: 24,
                      height: 24,
                    ),
                    title: Text(
                        ImpossiblocksLocalizations.of(context).text("arcade")),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/images/ic_classic.svg",
                      color: Colors.black54,
                      width: 24,
                      height: 24,
                    ),
                    title: Text(
                        ImpossiblocksLocalizations.of(context).text("classic")),
                  ),
                  // if (!widget.online) BottomNavigationBarItem(
                  //   icon: SvgPicture.asset(
                  //     "assets/images/ic_levels.svg",
                  //     color: Colors.black54,
                  //     width: 24,
                  //     height: 24,
                  //   ),
                  //   title: Text(
                  //       ImpossiblocksLocalizations.of(context).text("levels")),
                  // ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Theme.of(context).primaryColor,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
              body: _selectedIndex == 2
                  ? SizedBox.shrink()
                  : LeadboardsLocalContainer(
                      typeBoardGame: _selectedIndex == 0
                          ? TypeBoardGame.ARCADE
                          : TypeBoardGame.CLASSIC,
                    ));
        });
  }
}
