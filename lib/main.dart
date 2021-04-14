import 'dart:io';

import 'package:localization_generator/exceptions/generate_exception.dart';
import 'package:localization_generator/exceptions/missing_keys_exception.dart';
import 'package:localization_generator/generator/app_localized_file_generator.dart';
import 'package:localization_generator/generator/intl_generator.dart';
import 'package:localization_generator/loader/json_loader.dart';
import 'package:localization_generator/parser/icu_parser.dart';

import 'exceptions/parser_exception.dart';
import 'loader/loader.dart';

void doGenerate(Directory input, Directory output) {
  final loader = JSONLoader();
  final records = loader.load(input);
  checkMissingKey(records);

  final icuParser = ICUParser();
  final intlGenerator = IntlGenerator();
  final Map<String, List<String>> localizedMessage = {};
  for (final record in records) {
    final messages = record.records.entries.map((it) {
      try {
        final ats = icuParser.parse(it.value);
        final msg = intlGenerator.generate(it.key, ats);
        return msg;
      } on ParserException catch (e) {
        throw GenerateException(it.key, e);
      }
    }).toList();
    localizedMessage[record.locale] = messages;
  }
  final fileGenerator = AppLocalizedFileGenerator();
  final fileContent = fileGenerator.generate(localizedMessage);

  if (!output.existsSync()) {
    output.createSync();
  }
  File(output.path + '/localization.dart').writeAsStringSync(fileContent);
}

void checkMissingKey(List<Record> records) {
  final keys = records.fold<Set<String>>({}, (prev, it) {
    if (prev.length < it.records.keys.length) {
      return it.records.keys.toSet();
    }
    return prev;
  });

  for (final record in records) {
    if (record.records.keys.length != keys.length) {
      final localeKeys = record.records.keys.toSet();
      final missingKeys = keys.fold<Set<String>>({}, (acc, it) {
        if (!localeKeys.contains(it)) {
          acc.add(it);
        }
        return acc;
      });
      throw MissingKeysException(record.locale, missingKeys);
    }
  }
}
