import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ImpossiblocksLocalizations {
  var _rng = new Random();

  ImpossiblocksLocalizations(Locale locale) {
    this.locale = locale;
    _localizedValues = null;
  }

  Locale locale;
  static Map<dynamic, dynamic> _localizedValues;

  static ImpossiblocksLocalizations of(BuildContext context) {
    return Localizations.of<ImpossiblocksLocalizations>(
        context, ImpossiblocksLocalizations);
  }

  String title = "Impossiblocks";

  bool hasKey(String key) {
    return _localizedValues[key] != null;
  }

  String text(String key) {
    return _localizedValues[key] ?? '** $key not found';
  }

  String randomText(String key, int options) {
    return _localizedValues["${key}_${_rng.nextInt(options)}"] ??
        '** $key not found';
  }

  String replaceText(String key, String value, String replace) {
    return _localizedValues[key].replaceAll(value, replace) ??
        '** $key not found';
  }

  String replaceTextMap(String key, Map<String, String> values) {
    if (hasKey(key)) {
      String text = _localizedValues[key];
      values.forEach((v, r) {
        text = text.replaceAll(v, r);
      });
      return text;
    } else {
      return '** $key not found';
    }
  }

  static Future<ImpossiblocksLocalizations> load(Locale locale) async {
    ImpossiblocksLocalizations translations =
        new ImpossiblocksLocalizations(locale);
    String jsonContent =
        await rootBundle.loadString("locale/i18n_${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
    return translations;
  }
}

class ImpossiblocksLocalizationsDelegate
    extends LocalizationsDelegate<ImpossiblocksLocalizations> {

  final Locale forceLocale;

  const ImpossiblocksLocalizationsDelegate({@required this.forceLocale});

  @override
  bool isSupported(Locale locale) => [
        'en',
        'es',
        'pt',
        'de',
        'it',
        'hi',
        'fr',
        'ru',
        'ja',
        'zh'
      ].contains(locale.languageCode);

  @override
  Future<ImpossiblocksLocalizations> load(Locale locale) =>
      ImpossiblocksLocalizations.load(forceLocale ?? locale);

  @override
  bool shouldReload(ImpossiblocksLocalizationsDelegate old) => false;
}
