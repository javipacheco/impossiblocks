import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:impossiblocks/res/res_colors.dart';
import 'package:impossiblocks/ui/about/about_screen.dart';
import 'package:impossiblocks/ui/coins/coins_screen.dart';
import 'package:impossiblocks/ui/how_to_play/how_to_play_screen.dart';
import 'package:impossiblocks/ui/leadboards/leadboards_screen.dart';
import 'package:impossiblocks/ui/preferences/preferences_screen.dart';
import 'package:impossiblocks/ui/two_players/two_players_screen.dart';
import 'package:redux/redux.dart';
import 'package:impossiblocks/models/models.dart';
import 'package:impossiblocks/navigation/routes.dart';
import 'package:impossiblocks/ui/levels/levels_screen.dart';
import 'package:impossiblocks/ui/game/game_screen.dart';
import 'package:impossiblocks/ui/main/main_screen.dart';
import 'package:impossiblocks/reducers/app_state_reducer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:impossiblocks/localizations/impossiblocks_localizations.dart';
import 'package:impossiblocks/navigation/fade_transition.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

void main() async {
  //AudioPlayer.logEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<AppState>(AppState.fromJson),
  );

  final initialState = await persistor.load();

  final store = Store<AppState>(
    appReducer,
    initialState: initialState ?? AppState.init(),
    middleware: [persistor.createMiddleware()],
  );

  runZoned<Future<void>>(() async {
    runApp(ImpossiblocksApp(store: store));
  });
}

class ImpossiblocksApp extends StatelessWidget {
  final Store<AppState> store;

  ImpossiblocksApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          //debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            ImpossiblocksLocalizationsDelegate(
                forceLocale: store.state.preferences.locale != null
                    ? Locale(store.state.preferences.locale,
                        store.state.preferences.locale.toUpperCase())
                    : null),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale("en", "US"),
            const Locale("es", "ES"),
            const Locale("de", "DE"),
            const Locale("pt", "PT"),
            const Locale("it", "IT"),
            const Locale("hi", "IN"),
            const Locale("fr", "FR"),
            const Locale("ru", "RU"),
            const Locale("ja", "JA"),
            const Locale("zh", "ZH"),
          ],
          title: "Impossiblocks",
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: ResColors.primaryColor,
            accentColor: Colors.cyan[600],
            fontFamily: 'Trench',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: FadePageTransitionsBuilder(),
            }),
          ),
          routes: {
            ImpossiblocksRoutes.home: (context) => MainScreen(
                  title: ImpossiblocksLocalizations.of(context).title,
                ),
            ImpossiblocksRoutes.levels: (context) => LevelsScreen(
                  title: ImpossiblocksLocalizations.of(context).title,
                ),
            ImpossiblocksRoutes.levelsGame: (context) => GameScreen(
                  title: ImpossiblocksLocalizations.of(context).title,
                ),
            ImpossiblocksRoutes.leadboards: (context) => LeadboardsScreen(
                  title: ImpossiblocksLocalizations.of(context).title,
                ),
            ImpossiblocksRoutes.coins: (context) => CoinsScreen(
                  title: ImpossiblocksLocalizations.of(context).title,
                ),
            ImpossiblocksRoutes.twoPlayers: (context) => TwoPlayersScreen(),
            ImpossiblocksRoutes.howToPlayClassic: (context) =>
                HowToPlayScreen(arcade: false),
            ImpossiblocksRoutes.howToPlayArcade: (context) =>
                HowToPlayScreen(arcade: true),
            ImpossiblocksRoutes.preferences: (context) => PreferencesScreen(
                  title: ImpossiblocksLocalizations.of(context).text("settings"),
                ),
            ImpossiblocksRoutes.about: (context) => AboutScreen(
                  title: ImpossiblocksLocalizations.of(context).text("about"),
                ),
          },
        ));
  }
}
