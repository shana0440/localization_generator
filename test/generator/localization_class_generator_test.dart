import 'package:localization_generator/generator/localization_class_generator.dart';
import 'package:test/test.dart';

void main() {
  test('Test generate class', () {
    final classGenerator = LocalizationClassGenerator();
    final classStr = classGenerator.generate("en_US", [
      """String get hi => Intl.message("hi")""",
      """String get hello => Intl.message("hello")""",
    ]);
    expect(classStr, """
class en_US extends Localized {
  @override
  String get hi => Intl.message("hi");
  @override
  String get hello => Intl.message("hello");
}
""");
  });
}
