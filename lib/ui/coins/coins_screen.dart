import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/ui/coins/coins_container.dart';
import 'package:impossiblocks/ui/widgets/title_app_bar.dart';

class CoinsScreen extends StatefulWidget {
  CoinsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CoinsScreenState createState() => _CoinsScreenState();
}

class _CoinsScreenState extends State<CoinsScreen> {
  @override
  Widget build(BuildContext context) {
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
            child: TitleAppBar(
                title: ImpossiblocksLocalizations.of(context).text("coins")),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        body: CoinsContainer());
  }
}
