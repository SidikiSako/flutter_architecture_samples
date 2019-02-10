import 'dart:async';

import 'package:flutter/material.dart';

class MobxLocalizations {
  static MobxLocalizations of(BuildContext context) =>
      Localizations.of<MobxLocalizations>(context, MobxLocalizations);

  String get appTitle => 'Mobx Example';
}

class MobxLocalizationsDelegate
    extends LocalizationsDelegate<MobxLocalizations> {
  const MobxLocalizationsDelegate();

  @override
  Future<MobxLocalizations> load(Locale locale) =>
      Future(() => MobxLocalizations());

  @override
  bool shouldReload(MobxLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
