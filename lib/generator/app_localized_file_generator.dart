import 'package:localization_generator/generator/app_localized_class_generator.dart';
import 'package:localization_generator/generator/localization_class_generator.dart';

class AppLocalizedFileGenerator {
  String generate(Map<String, List<String>> localedMessage) {
    final appLocalizedClassGenerator = AppLocalizedClassGenerator();
    final localizationClassGenerator = LocalizationClassGenerator();
    final locales = localedMessage.keys.toList();
    final messages = localedMessage[locales.first];

    return """
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

${appLocalizedClassGenerator.generate(locales, messages)}

${localedMessage.entries.map((it) => localizationClassGenerator.generate(it.key, it.value)).join('\n')}""";
  }
}
