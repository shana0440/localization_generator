import 'package:localization_generator/generator/intl_generator.dart';
import 'package:localization_generator/parser/icu_parser.dart';
import 'package:test/test.dart';

String generate(String key, String msg) {
  final parser = ICUParser();
  final ats = parser.parse(msg);
  final generator = IntlGenerator();
  return generator.generate(key, ats);
}

void main() {
  test('Test generate normal message', () {
    final msg = generate("msg", "Normal message");
    expect(msg, """String get msg => Intl.message("Normal message")""");
  });

  test('Test generate arguments message', () {
    final msg = generate("hello", "Hello {name}!");
    expect(msg, """String hello({dynamic name}) => Intl.message("Hello \$name!")""");
  });

  test('Test generate select message', () {
    final msg = generate("price", "100 {currency, select, TWD{NT} HKD{HK} other{\$}}");
    expect(msg, """String price({dynamic currency}) => Intl.message("100 ") + Intl.select(currency, {"TWD": Intl.message("NT"), "HKD": Intl.message("HK"), "other": Intl.message("\$")})""");
  });

  test('Test generate gender message', () {
    final msg = generate("gender", "{gender, gender, female{female} male{male} other{other}}");
    expect(msg, """String gender({dynamic gender}) => Intl.gender(gender, female: Intl.message("female"), male: Intl.message("male"), other: Intl.message("other"))""");
  });

  test('Test generate plural message', () {
    final msg = generate("plural", "{count, plural, =0{no reply} =1{1 reply} other{# replies}}");
    expect(msg, """String plural({dynamic count}) => Intl.plural(count, zero: Intl.message("no reply"), one: Intl.message("1 reply"), other: Intl.message("\$count replies"))""");
  });

  test('Test nested message', () {
    final msg = generate(
      "party",
      """{gender_of_host, gender,
      female {{num_guests, plural,
          =0 {{host} doest not give a party.}
          =1 {{host} invites {guest} to her party.}
          =2 {{host} invites {guest} and one other person to her party.}
          other {{host} invites {guest} and # other people to her party.}}}}"""
    );
    expect(msg, """String party({dynamic gender_of_host, dynamic num_guests, dynamic host, dynamic guest}) => Intl.gender(gender_of_host, female: Intl.plural(num_guests, zero: Intl.message("\$host doest not give a party."), one: Intl.message("\$host invites \$guest to her party."), two: Intl.message("\$host invites \$guest and one other person to her party."), other: Intl.message("\$host invites \$guest and \$num_guests other people to her party.")))""");
  });
}
