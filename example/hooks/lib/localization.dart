// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

class hooksLocalizations {
  static hooksLocalizations of(BuildContext context) {
    return Localizations.of<hooksLocalizations>(context, hooksLocalizations);
  }

  String get appTitle => "hooks Example";
}

class hooksLocalizationsDelegate
    extends LocalizationsDelegate<hooksLocalizations> {
  @override
  Future<hooksLocalizations> load(Locale locale) =>
      Future(() => hooksLocalizations());

  @override
  bool shouldReload(hooksLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains("en");
}
