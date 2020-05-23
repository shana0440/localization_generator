import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Localized {
  static const delegate = LocalizedDelegate();

  static Localized of(BuildContext context) {
    return Localizations.of<Localized>(context, Localized);
  }

  String get hi => Intl.message("Hi");
  String hello({dynamic name}) => Intl.message("Hello $name");
  String price({dynamic currency}) => Intl.message("100 ") + Intl.select(currency, {"TWD": Intl.message("NT"), "HKD": Intl.message("HK"), "other": Intl.message("\$")});
}

class LocalizedDelegate extends LocalizationsDelegate<Localized> {
  List<Locale> get supportedLocales => [
    Locale.fromSubtags(languageCode: "en", countryCode: "US"),
    Locale.fromSubtags(languageCode: "zh", scriptCode: "Hant"),
  ];

  const LocalizedDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.contains(locale);
  }

  @override
  Future<Localized> load(Locale locale) async {
    final String localeName = Intl.canonicalizedLocale(locale.toString());
    Intl.defaultLocale = localeName;
    switch (localeName) {
      case "en_US":
        return new en_US();
      case "zh_Hant":
        return new zh_Hant();
      default:
        return null;
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localized> old) {
    return true;
  }
}

class en_US extends Localized {
  @override
  TextDirection get textDirection => TextDirection.LTR;
  
  @override
  String get hi => Intl.message("Hi");
  @override
  String hello({dynamic name}) => Intl.message("Hello $name");
  @override
  String price({dynamic currency}) => Intl.message("100 ") + Intl.select(currency, {"TWD": Intl.message("NT"), "HKD": Intl.message("HK"), "other": Intl.message("\$")});
}
    
class zh_Hant extends Localized {
  @override
  TextDirection get textDirection => TextDirection.LTR;
  
  @override
  String get hi => Intl.message("Hi");
  @override
  String hello({dynamic name}) => Intl.message("Hello $name");
  @override
  String price({dynamic currency}) => Intl.message("100 ") + Intl.select(currency, {"TWD": Intl.message("NT"), "other": Intl.message("$")});
}
    