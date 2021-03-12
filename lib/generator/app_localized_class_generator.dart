import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'package:localization_generator/dart/string.dart';

class AppLocalizedClassGenerator {
  String generate(List<String> locales, List<String> messages) {
    final canonicalizedLocales = locales.map<Locale>(
      (it) => Locale.parse(it),
    );
    final msg = messages.map((it) => "$it;".indent(2)).join("\n");
    final loadLocalizationSwitchCase = """
switch (localeName) {
${canonicalizedLocales.map((it) => Intl.canonicalizedLocale(it.toLanguageTag())).map((it) => 'case "$it":\n  return new $it();'.indent(2)).join("\n")}
  default:
    throw Exception('Could not find a locale: ' + localeName);
}"""
        .indent(4);

    final supportLocale = canonicalizedLocales
        .map((it) => _convertLocaleToSubtagFormat(it))
        .map((it) => "$it,".indent(4))
        .join('\n');

    return """
class Localized {
  static const delegate = LocalizedDelegate();

  static Localized of(BuildContext context) {
    return Localizations.of<Localized>(context, Localized)!;
  }

$msg
}

class LocalizedDelegate extends LocalizationsDelegate<Localized> {
  List<Locale> get supportedLocales => [
$supportLocale
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
$loadLocalizationSwitchCase
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localized> old) {
    return true;
  }
}""";
  }
}

String _convertLocaleToSubtagFormat(Locale locale) {
  final parameters = [];
  if (locale.languageCode != null) {
    parameters.add('languageCode: "${locale.languageCode}"');
  }
  if (locale.countryCode != null) {
    parameters.add('countryCode: "${locale.countryCode}"');
  }
  if (locale.scriptCode != null) {
    parameters.add('scriptCode: "${locale.scriptCode}"');
  }
  return "Locale.fromSubtags(${parameters.join(', ')})";
}
