import 'package:localization_generator/exceptions/parser_exception.dart';

import 'invalid_argument_exception.dart';
import 'invalid_choice_exception.dart';
import 'invalid_option_exception.dart';
import 'missing_close_curly_exception.dart';
import 'missing_open_curly_exception.dart';

class GenerateException extends Error {
  final ParserException exception;
  final String key;

  GenerateException(this.key, this.exception);

  @override
  String toString() {
    switch (exception.runtimeType) {
      case InvalidArgumentException:
        return "${key}: argument should start with letter compose by letter, _ or digits";
      case InvalidChoiceException:
        return "${key}: choice only support select, plural, gender";
      case InvalidOptionException:
        final typedException = exception as InvalidOptionException;
        return "${key}: ${typedException.option} must be one of the ${typedException.validOptions}";
      case MissingCloseCurlyException:
        return "${key}: missing {";
      case MissingOpenCurlyException:
        return "${key}: missing }";
      default:
        return "";
    }
  }
}
