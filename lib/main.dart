import 'dart:io';

import 'package:localization_generator/exceptions/generate_exception.dart';
import 'package:localization_generator/generator/app_localized_file_generator.dart';
import 'package:localization_generator/generator/intl_generator.dart';
import 'package:localization_generator/loader/json_loader.dart';
import 'package:localization_generator/parser/icu_parser.dart';

import 'exceptions/parser_exception.dart';

void doGenerate(Directory input, Directory output) {
  final loader = JSONLoader();
  final records = loader.load(input);
  final icuParser = ICUParser();
  final intlGenerator = IntlGenerator();
  final Map<String, List<String>> localedMessage = {};
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
    localedMessage[record.locale] = messages;
  }
  final fileGenerator = AppLocalizedFileGenerator();
  final fileContent = fileGenerator.generate(localedMessage);

  if (!output.existsSync()) {
    output.createSync();
  }
  File(output.path + '/localization.dart').writeAsStringSync(fileContent);
}
