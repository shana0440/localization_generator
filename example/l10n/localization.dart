import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Localized {
  static const delegate = LocalizedDelegate();

  static Localized of(BuildContext context) {
    final localized = Localizations.of<Localized>(context, Localized);
    if (localized == null)
      throw Exception('Could not find a Localization with the given context.');
    return localized;
  }

  String get hi => Intl.message("Hi");
  String hello({dynamic name}) => Intl.message("Hello $name");
  String price({dynamic currency}) =>
      Intl.message("100 ") +
      Intl.select(
          currency, {"TWD": Intl.message("NT"), "other": Intl.message("\$")});
  String gender({dynamic gender}) =>
      Intl.message("gender: ") +
      Intl.gender(gender,
          female: Intl.message("female"),
          male: Intl.message("male"),
          other: Intl.message("other"));
  String reply({dynamic count}) => Intl.plural(count,
      zero: Intl.message("no reply"),
      one: Intl.message("1 reply"),
      other: Intl.message("$count replies"));
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
        throw Exception('Could not find the locale: ' + localeName);
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localized> old) {
    return true;
  }
}

class en extends Localized {
  @override
  String get hi => Intl.message("Hi");
  @override
  String hello({dynamic name}) => Intl.message("Hello $name");
  @override
  String price({dynamic currency}) =>
      Intl.message("100 ") +
      Intl.select(
          currency, {"TWD": Intl.message("NT"), "other": Intl.message("\$")});
  @override
  String gender({dynamic gender}) =>
      Intl.message("gender: ") +
      Intl.gender(gender,
          female: Intl.message("female"),
          male: Intl.message("male"),
          other: Intl.message("other"));
  @override
  String reply({dynamic count}) => Intl.plural(count,
      zero: Intl.message("no reply"),
      one: Intl.message("1 reply"),
      other: Intl.message("$count replies"));
}

class zh_Hans extends Localized {
  @override
  String get hi => Intl.message("(簡)嗨");
  @override
  String hello({dynamic name}) => Intl.message("(簡)你好 $name");
  @override
  String price({dynamic currency}) =>
      Intl.message("(簡)100 ") +
      Intl.select(
          currency, {"TWD": Intl.message("台幣"), "other": Intl.message("\$")});
  @override
  String gender({dynamic gender}) =>
      Intl.message("(簡)gender: ") +
      Intl.gender(gender,
          female: Intl.message("女"),
          male: Intl.message("男"),
          other: Intl.message("第三性"));
  @override
  String reply({dynamic count}) =>
      Intl.message("(簡)") +
      Intl.plural(count,
          zero: Intl.message("沒有回覆"),
          one: Intl.message("1個回覆"),
          other: Intl.message("$count個回覆"));
}

class zh_Hant extends Localized {
  @override
  String get hi => Intl.message("嗨");
  @override
  String hello({dynamic name}) => Intl.message("你好 $name");
  @override
  String price({dynamic currency}) =>
      Intl.message("100 ") +
      Intl.select(
          currency, {"TWD": Intl.message("台幣"), "other": Intl.message("\$")});
  @override
  String gender({dynamic gender}) =>
      Intl.message("gender: ") +
      Intl.gender(gender,
          female: Intl.message("女"),
          male: Intl.message("男"),
          other: Intl.message("第三性"));
  @override
  String reply({dynamic count}) => Intl.plural(count,
      zero: Intl.message("沒有回覆"),
      one: Intl.message("1個回覆"),
      other: Intl.message("$count個回覆"));
}
