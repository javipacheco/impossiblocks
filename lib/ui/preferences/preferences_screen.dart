import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/navigation/routes.dart';
import 'package:impossiblocks/res/res_styles.dart';
import 'package:impossiblocks/ui/preferences/language_dialog.dart';
import 'package:impossiblocks/ui/preferences/viewmodels/preferences_screen_view_model.dart';

class PreferencesScreen extends StatefulWidget {
  PreferencesScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PreferencesScreenViewModel>(
        converter: (store) => PreferencesScreenViewModel.build(store),
        builder: (context, viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    ImpossiblocksLocalizations.of(context).text("language"),
                    style: ResStyles.big(viewModel.sizeScreen,
                        color: Colors.black87),
                  ),
                  subtitle: Text(
                    ImpossiblocksLocalizations.of(context)
                        .text("select_language"),
                    style: ResStyles.normal(viewModel.sizeScreen,
                        color: Colors.black54),
                  ),
                  onTap: () {
                    LanguageDialog.show(context);
                  },
                ),
                SwitchListTile(
                  value: !viewModel.userRemoveAnimations,
                  title: Text(
                    ImpossiblocksLocalizations.of(context).text("animations"),
                    style: ResStyles.big(viewModel.sizeScreen,
                        color: Colors.black87),
                  ),
                  subtitle: Text(
                    ImpossiblocksLocalizations.of(context)
                        .text("animations_msg"),
                    style: ResStyles.normal(viewModel.sizeScreen,
                        color: Colors.black54),
                  ),
                  onChanged: (value) {
                    viewModel.onChangeAnimation();
                  },
                ),
                ListTile(
                  title: Text(
                    ImpossiblocksLocalizations.of(context).text("about"),
                    style: ResStyles.big(viewModel.sizeScreen,
                        color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ImpossiblocksRoutes.about);
                  },
                ),
              ],
            ),
          );
        });
  }
}
