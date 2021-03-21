import 'package:localization_generator/generator/app_localized_class_generator.dart';
import 'package:test/test.dart';

void main() {
  test('Test generate class', () {
    final classGenerator = AppLocalizedClassGenerator();
    final classStr = classGenerator.generate([
      "en_US",
      "zh_Hant"
    ], [
      """String get hi => Intl.message("hi")""",
      """String get hello => Intl.message("hello")""",
    ]);

    expect(classStr, """
class Localized {
  static const delegate = LocalizedDelegate();

  static Localized of(BuildContext context) {
    final localized = Localizations.of<Localized>(context, Localized);
    if(localized == null) throw Exception('Could not find a Localization with the given context.');
    return localized;
  }

  String get hi => Intl.message("hi");
  String get hello => Intl.message("hello");
}

class LocalizedDelegate extends LocalizationsDelegate<Localized> {
  List<Locale> get supportedLocales => [
    Locale.fromSubtags(languageCode: "en", countryCode: "US"),
    Locale.fromSubtags(languageCode: "zh", scriptCode: "Hant"),
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
    switch (localeName) {
      case "en_US":
        return new en_US();
      case "zh_Hant":
        return new zh_Hant();
      default:
        throw Exception('Could not find the locale: ' + localeName);
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localized> old) {
    return true;
  }
}""");
  });
}
