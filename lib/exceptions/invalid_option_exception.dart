import 'package:localization_generator/exceptions/parser_exception.dart';

class InvalidOptionException extends ParserException {
  final List<String> validOptions;
  final String option;

  InvalidOptionException(this.validOptions, this.option);
}
