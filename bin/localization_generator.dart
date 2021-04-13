library localization_generator;

import 'dart:io';

import 'package:args/args.dart';
import 'package:localization_generator/exceptions/generate_exception.dart';
import 'package:localization_generator/exceptions/invalid_argument_exception.dart';
import 'package:localization_generator/exceptions/invalid_choice_exception.dart';
import 'package:localization_generator/exceptions/invalid_option_exception.dart';
import 'package:localization_generator/exceptions/missing_close_curly_exception.dart';
import 'package:localization_generator/exceptions/missing_open_curly_exception.dart';
import 'package:localization_generator/main.dart';

main(List<String> args) {
  String output = "";
  String input = "";

  var parser = ArgParser();
  parser.addOption(
    'output',
    help: 'generate localization file to output folder',
    callback: (value) => output = value!,
  );
  parser.addOption(
    'input',
    help: 'localized json file folder',
    callback: (value) => input = value!,
  );
  parser.parse(args);

  try {
    doGenerate(Directory(input), Directory(output));
  } on GenerateException catch (e) {
    stderr.writeln(e.toString());
    exit(1);
  }
}
