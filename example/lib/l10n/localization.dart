import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Localized {
  static const delegate = LocalizedDelegate();

  static Localized of(BuildContext context) {
    return Localizations.of<Localized>(context, Localized);
  }

  String get Title => Intl.message("Localization Demo");
  String get Home => Intl.message("Home");
  String CounterDescription({dynamic count}) => Intl.message("You have pushed the button this many times: $count");
  String Date({dynamic start, dynamic end}) => Intl.message("From $start\n to $end");
}

class LocalizedDelegate extends LocalizationsDelegate<Localized> {
  List<Locale> get supportedLocales => [
    Locale.fromSubtags(languageCode: "en"),
    Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans"),
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
      case "en":
        return new en();
      case "zh_Hans":
        return new zh_Hans();
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

class en extends Localized {
  @override
  TextDirection get textDirection => TextDirection.LTR;
  
  @override
  String get Title => Intl.message("Localization Demo");
  @override
  String get Home => Intl.message("Home");
  @override
  String CounterDescription({dynamic count}) => Intl.message("You have pushed the button this many times: $count");
  @override
  String Date({dynamic start, dynamic end}) => Intl.message("From $start\n to $end");
}

class zh_Hans extends Localized {
  @override
  TextDirection get textDirection => TextDirection.LTR;
  
  @override
  String get Title => Intl.message("测试");
  @override
  String get Home => Intl.message("首页");
  @override
  String CounterDescription({dynamic count}) => Intl.message("你按了按钮 $count 下:");
  @override
  String Date({dynamic end, dynamic start}) => Intl.message("结束于 $end\n 开始于 $start");
}

class zh_Hant extends Localized {
  @override
  TextDirection get textDirection => TextDirection.LTR;
  
  @override
  String get Title => Intl.message("測試");
  @override
  String get Home => Intl.message("首頁");
  @override
  String CounterDescription({dynamic count}) => Intl.message("你按了按鈕 $count 下:");
  @override
  String Date({dynamic end, dynamic start}) => Intl.message("結束於 $end\n 開始於 $start");
}
