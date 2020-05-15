import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/preferences/viewmodels/preferences_screen_view_model.dart';
import 'package:store_redirect/store_redirect.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PreferencesScreenViewModel>(
        converter: (store) => PreferencesScreenViewModel.build(store),
        builder: (context, viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 240,
                    child: Image.asset(
                      'assets/gadestudios.png',
                      width: MediaQuery.of(context).size.width * 0.65,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        ImpossiblocksLocalizations.of(context)
                            .text("about_msg"),
                        style: ResStyles.normal(viewModel.sizeScreen),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        ImpossiblocksLocalizations.of(context)
                            .text("about_people_1"),
                        style: ResStyles.normal(viewModel.sizeScreen),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        ImpossiblocksLocalizations.of(context)
                            .text("about_people_2"),
                        style: ResStyles.normal(viewModel.sizeScreen),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (Platform.isAndroid)
                    SizedBox(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          ImpossiblocksLocalizations.of(context)
                              .text("other_projects"),
                          style: ResStyles.big(viewModel.sizeScreen),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  if (Platform.isAndroid)
                    RaisedButton(
                      color: ResColors.colorTile2,
                      onPressed: () {
                        StoreRedirect.redirect(
                            androidAppId: "com.kidslauncher",
                            iOSAppId: "1477714898");
                      },
                      child: Text(
                        "Kids Launcher",
                        style: ResStyles.normal(viewModel.sizeScreen,
                            color: Colors.white),
                      ),
                    )
                ],
              ),
            ),
          );
        });
  }
}
