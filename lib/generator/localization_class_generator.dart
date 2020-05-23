import 'package:intl/intl.dart';
import 'package:localization_generator/dart/string.dart';

class LocalizationClassGenerator {
  String generate(String aLocale, List<String> messages) {
    final locale = Intl.canonicalizedLocale(aLocale);
    final msg = messages.map((it) => "@override\n$it;".indent(2)).join("\n");
    return """
class $locale extends Localized {
$msg
}
""";
  }
}
