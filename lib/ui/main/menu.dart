import 'dart:io';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/navigation/routes.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/main/viewmodels/main_screen_view_model.dart';
import 'package:impossiblocks/ui/widgets/dialogs/simple_alert_dialog.dart';
import 'package:share/share.dart';

class Menu extends StatefulWidget {
  final bool opened;

  final Function onBackPressed;

  Menu({Key key, @required this.opened, @required this.onBackPressed})
      : super(key: key);

  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  AnimationController _menuAnimController;
  Animation<double> _menuAnim;

  @override
  void initState() {
    _menuAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _menuAnim = CurvedAnimation(
      parent: _menuAnimController,
      curve: Curves.easeIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _menuAnimController.dispose();
    super.dispose();
  }

  bool _isMenuOpened() =>
      _menuAnimController.status == AnimationStatus.forward ||
      _menuAnimController.status == AnimationStatus.completed;

  void _showHideMenu() {
    if (_isMenuOpened()) {
      _menuAnimController.reverse();
    } else {
      _menuAnimController.forward();
    }
  }

  @override
  void didUpdateWidget(Menu oldWidget) {
    if (widget.opened != oldWidget.opened) {
      _showHideMenu();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double separation = 14;
    return StoreConnector<AppState, MainScreenViewModel>(
        converter: (store) => MainScreenViewModel.build(store),
        builder: (context, viewModel) {
          return CircularRevealAnimation(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                color: ResColors.colorTile1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        'assets/logo_big.png',
                        width: MediaQuery.of(context).size.width * 0.65,
                      ),
                      if (viewModel.isPremium)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SvgPicture.asset(
                                  "assets/images/ic_medal.svg",
                                  color: Colors.yellow.withAlpha(200),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              Text(
                                ImpossiblocksLocalizations.of(context)
                                    .text("you_are_premium"),
                                style: ResStyles.normal(viewModel.sizeScreen,
                                    color: Colors.white70),
                              )
                            ],
                          ),
                        ),
                      Divider(
                        color: Colors.white54,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildFlatButton(
                              context,
                              viewModel.sizeScreen,
                              "assets/images/ic_volume_${viewModel.musicVolume}.svg",
                              ImpossiblocksLocalizations.of(context)
                                  .text("music"),
                              30,
                              () => viewModel.changeMusicVolume()),
                          SizedBox(
                            height: 30,
                          ),
                          buildFlatButton(
                              context,
                              viewModel.sizeScreen,
                              "assets/images/ic_volume_${viewModel.soundVolume}.svg",
                              ImpossiblocksLocalizations.of(context)
                                  .text("sound"),
                              30,
                              () => viewModel.changeSoundVolume()),
                        ],
                      ),
                      SizedBox(
                        height: separation,
                      ),
                      buildFlatButton(
                          context,
                          viewModel.sizeScreen,
                          "assets/images/ic_share.svg",
                          ImpossiblocksLocalizations.of(context).text("share"),
                          26, () {
                        Share.share(ImpossiblocksLocalizations.of(context)
                            .text("share_app_msg"));
                      }),
                      SizedBox(
                        height: separation,
                      ),
                      buildFlatButton(
                          context,
                          viewModel.sizeScreen,
                          "assets/images/ic_preferences.svg",
                          ImpossiblocksLocalizations.of(context)
                              .text("more_settings"),
                          26, () {
                        Navigator.pushNamed(
                            context, ImpossiblocksRoutes.preferences);
                      }),
                      SizedBox(
                        height: 30,
                      ),
                      FloatingActionButton(
                        heroTag: null,
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.close),
                        onPressed: widget.onBackPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            animation: _menuAnim,
            center: Offset(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
          );
        });
  }

  FlatButton buildFlatButton(BuildContext context, SizeScreen sizeScreen,
      String icon, String text, double size, Function onPressed) {
    return FlatButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            icon,
            color: Colors.white70,
            width: size,
            height: size,
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            text,
            style: ResStyles.big(
              sizeScreen,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
