class Locale {
  final String languageCode;
  final String countryCode;

  Locale._(this.languageCode, [this.countryCode]);

  factory Locale.fromString(String code) {
    final codes = code.split("_");
    final languageCode = codes.first;
    final countryCode = codes.length > 1 ? codes[1] : "";
    return Locale._(languageCode, countryCode);
  }

  String get toClassName {
    final country = countryCode.isNotEmpty
        ? "${countryCode[0].toUpperCase()}${countryCode.substring(1)}"
        : "";
    return "$languageCode$country";
  }

  String get toCase {
    if (countryCode.isEmpty) {
      return languageCode;
    }
    return "${languageCode}_$countryCode";
  }
}
