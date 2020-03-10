import 'dart:io';

import 'package:localization_generator/locale.dart';

import './template.dart';

class Generator {
  Directory output;

  Generator(String output) {
    this.output = Directory(output);
  }

  Map<Locale, Map> localizations = Map();

  void load(String locale, Map json) {
    localizations[Locale.fromString(locale)] = json;
  }

  void generate() {
    if (!this.output.existsSync()) {
      this.output.createSync();
    }
    var template = getTemplate();
    template = replaceSupportedLanguages(template);
    template = replaceLocalizedGenerateFactory(template);
    template = replaceFirstLocalized(template);
    template = replaceOtherLocalizedClasses(template);
    File(output.path + '/localization.dart').writeAsStringSync(template);
  }

  String getTemplate() {
    return template;
  }

  String replaceSupportedLanguages(String template) {
    var supportedLanguages = this.localizations.keys.map((locale) => indent(
          6,
          'Locale.fromSubtags(languageCode: "${locale.languageCode}", scriptCode: "${locale.scriptCode}"),',
        ));
    return template.replaceFirst(
      '{SupportedLanguages}',
      supportedLanguages.join('\n'),
    );
  }

  String replaceLocalizedGenerateFactory(String template) {
    var supportedLanguages = this.localizations.keys.map((locale) =>
        indent(8, 'case "${locale.toCase}":\n') +
        indent(
          10,
          "return SynchronousFuture<Localized>(const \$${locale.toClassName}());",
        ));
    return template.replaceFirst(
      '{LocalizedGenerateFactory}',
      supportedLanguages.join('\n'),
    );
  }

  String replaceFirstLocalized(String template) {
    var first = this.localizations.keys.first;
    var localized = this.localizations[first];
    var localizedStrings = generateLocalizedStrings(localized);
    return template
        .replaceFirst('{FirstLocalizedString}', localizedStrings)
        .replaceFirst('{FirstLocalizedClass}', '''
class \$${first.toClassName} extends Localized {
  const \$${first.toClassName}();
}''');
  }

  String replaceOtherLocalizedClasses(String template) {
    var classes = this.localizations.keys.skip(1).map((key) {
      var localized = this.localizations[key];
      var localizedStrings = generateLocalizedStrings(localized);
      return '''
class \$${key.toClassName} extends Localized {
  const \$${key.toClassName}();

  @override
  TextDirection get textDirection => TextDirection.ltr;

  @override
$localizedStrings
}
''';
    });
    return template.replaceFirst('{OtherLocalizedClasses}', classes.join('\n'));
  }

  String generateLocalizedStrings(Map json) {
    return json
        .map(
          (key, value) => MapEntry(
            key,
            indent(2, 'String get $key => "$value";'),
          ),
        )
        .values
        .join('\n');
  }

  String indent(int number, String str) {
    return ' ' * number + str;
  }
}
