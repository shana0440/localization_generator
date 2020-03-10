library localization_generator;

import 'package:args/args.dart';
import 'package:path/path.dart';

import 'package:localization_generator/generator.dart';
import 'package:localization_generator/loader.dart';

main(List<String> args) {
  var output = "";
  var input = "";

  var parser = ArgParser();
  parser.addOption(
    'output',
    help: 'generate localization file to output folder',
    callback: (value) => output = value,
  );
  parser.addOption(
    'input',
    help: 'localized json file folder',
    callback: (value) => input = value,
  );
  parser.parse(args);

  final generator = Generator(output);
  final loader = JSONLoader(input);
  loader.onLoaded((filename, json) {
    final locale = basenameWithoutExtension(filename);
    generator.load(locale, json);
  });
  loader.load();
  generator.generate();
}
