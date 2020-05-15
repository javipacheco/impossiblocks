import 'package:flutter/material.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/ui/widgets/title_app_bar.dart';
import 'levels_list_container.dart';
import 'package:impossiblocks/ui/widgets/rounded_container.dart';

class LevelsScreen extends StatefulWidget {
  LevelsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LevelsScreenState createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
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
            child: TitleAppBar(title: ImpossiblocksLocalizations.of(context).text("levels")),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: RoundedContainer(
            color: Colors.white, child: LevelsListContainer()));
  }
}
