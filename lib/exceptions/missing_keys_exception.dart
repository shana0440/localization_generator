import 'localization_generator_exception.dart';

class MissingKeysException extends LocalizationGeneratorException {
  final String locale;
  final Set<String> missingKeys;

  MissingKeysException(this.locale, this.missingKeys);

  @override
  String toString() {
    return "${locale} is missing the following keys: ${missingKeys.join(',')}";
  }
}
