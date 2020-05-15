import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/navigation/routes.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/services/repository_service.dart';
import 'package:impossiblocks/ui/main/edit_user_dialog.dart';
import 'package:impossiblocks/ui/main/menu.dart';
import 'package:impossiblocks/ui/main/users_dialog.dart';
import 'package:impossiblocks/ui/main/viewmodels/main_screen_view_model.dart';
import 'package:impossiblocks/ui/widgets/avatar.dart';
import 'package:impossiblocks/ui/widgets/start_docked_floating.dart';
import 'package:impossiblocks/ui/widgets/title_app_bar.dart';
import 'main_container.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  bool opened;

  @override
  void initState() {
    opened = false;
    super.initState();
  }

  void _showModalBottomSheet(
      BuildContext context, MainScreenViewModel viewModel) {
    showModalBottomSheet(context: context, builder: (context) => UsersDialog());
  }

  @override
  Widget build(BuildContext context) {
    double widthActionButton = (MediaQuery.of(context).size.width - 65) / 4;
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: StoreConnector<AppState, MainScreenViewModel>(
            converter: (store) => MainScreenViewModel.build(store),
            onInitialBuild: (viewModel) {
              viewModel.onReloadSizeScreen(context);
              if (!viewModel.userChangedEntering) {
                viewModel.userWasChangedEntering();
                EditUserDialog.show(context, (name, avatar) {
                  viewModel.onUpdateCurrentUserFirstTime(name, avatar);
                },
                    defaultName: RepositoryService.guestName,
                    defaultMessage: ImpossiblocksLocalizations.of(context)
                        .text("welcome_message"));
              }
              viewModel.onLoadUsers();
            },
            builder: (context, viewModel) {
              return WillPopScope(
                onWillPop: () async {
                  if (opened) {
                    setState(() {
                      opened = false;
                    });
                    return false;
                  } else {
                    return true;
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        title: Center(
                          child: TitleAppBar(title: null),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                      ),
                      floatingActionButtonLocation:
                          StartDockedFloatingActionButtonLocation(),
                      floatingActionButton: FloatingActionButton(
                        child:
                            IconAvatar(avatar: viewModel.currentUser?.avatar),
                        backgroundColor: viewModel.currentUser?.getColor(),
                        onPressed: () =>
                            _showModalBottomSheet(context, viewModel),
                      ),
                      bottomNavigationBar: BottomAppBar(
                          shape: CircularNotchedRectangle(),
                          color: ResColors.primaryColor,
                          notchMargin: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                buildUserNameAction(viewModel.sizeScreen,
                                    viewModel.currentUser?.name ?? ""),
                                buildNavigationAction(
                                    context,
                                    viewModel.sizeScreen,
                                    "ic_podium",
                                    ImpossiblocksLocalizations.of(context)
                                        .text("local"),
                                    widthActionButton, () {
                                  Navigator.pushNamed(
                                      context, ImpossiblocksRoutes.leadboards);
                                }),
                                buildCoinsNavigationAction(
                                    context,
                                    viewModel.sizeScreen,
                                    viewModel.currentUser?.coins ?? 0,
                                    widthActionButton, () {
                                  Navigator.pushNamed(
                                      context, ImpossiblocksRoutes.coins);
                                }),
                                buildNavigationAction(
                                    context,
                                    viewModel.sizeScreen,
                                    "ic_more",
                                    ImpossiblocksLocalizations.of(context)
                                        .text("more"),
                                    widthActionButton, () {
                                  //viewModel.onAddingLevels();
                                  setState(() {
                                    opened = true;
                                  });
                                }),
                              ],
                            ),
                          )),
                      body: new MainContainer(),
                    ),
                    Positioned.fill(
                        child: Menu(
                      opened: opened,
                      onBackPressed: () {
                        setState(() {
                          opened = false;
                        });
                      },
                    ))
                  ],
                ),
              );
            }));
  }

  Widget buildUserNameAction(SizeScreen sizeScreen, String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: SizedBox(
        width: 55,
        height: 42,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            name,
            maxLines: 1,
            style: ResStyles.tooltip(sizeScreen, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildNavigationAction(BuildContext context, SizeScreen sizeScreen,
      String icon, String tooltip, double width, Function onPressed) {
    return SizedBox(
      width: width,
      child: FlatButton(
        onPressed: () => onPressed(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              "assets/images/$icon.svg",
              color: Colors.white,
              width: 30,
              height: 30,
            ),
            Flexible(
              child: Text(
                tooltip,
                overflow: TextOverflow.ellipsis,
                style: ResStyles.tooltip(sizeScreen, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCoinsNavigationAction(BuildContext context, SizeScreen sizeScreen,
      int coins, double width, Function onPressed) {
    String coinsStr = coins >= 10000
        ? "${coins ~/ 1000}k"
        : coins >= 1000 ? "+${coins ~/ 1000}k" : coins.toString();
    return SizedBox(
      width: width,
      child: FlatButton(
        onPressed: () => onPressed(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 45,
              height: 30,
              child: Center(
                child: Text(
                  coinsStr,
                  overflow: TextOverflow.ellipsis,
                  style: ResStyles.coinsInNavigationBar,
                ),
              ),
            ),
            Flexible(
              child: Text(
                ImpossiblocksLocalizations.of(context).text("coins"),
                overflow: TextOverflow.ellipsis,
                style: ResStyles.tooltip(sizeScreen, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
