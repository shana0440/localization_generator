class Locale {
  final String languageCode;
  final String scriptCode;

  Locale._(this.languageCode, [this.scriptCode]);

  factory Locale.fromString(String code) {
    final codes = code.split("_");
    final languageCode = codes.first;
    final countryCode = codes.length > 1 ? codes[1] : "";
    return Locale._(languageCode, countryCode);
  }

  String get toClassName {
    final country = scriptCode.isNotEmpty
        ? "${scriptCode[0].toUpperCase()}${scriptCode.substring(1)}"
        : "";
    return "$languageCode$country";
  }

  String get toCase {
    if (scriptCode.isEmpty) {
      return languageCode;
    }
    return "${languageCode}_$scriptCode";
  }

  String get toLocale {
    if (scriptCode.isNotEmpty) {
      return 'Locale.fromSubtags(languageCode: "$languageCode", scriptCode: "$scriptCode"),';
    } else {
      return 'Locale("$languageCode", ""),';
    }
  }
}
