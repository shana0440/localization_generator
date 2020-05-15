import 'package:test/test.dart';

import 'package:localization_generator/parser/parser.dart';
import 'package:localization_generator/parser/icu_parser.dart';

void main() {
  test('Test parse normal message', () {
    final parser = ICUParser();
    final ast = parser.parse("Normal message");
    expect(ast[0].value, "Normal message");
  });

  test('Test parse arguments message', () {
    final parser = ICUParser();
    final ast = parser.parse("Hello {name}!");
    expect(ast[0].value, "Hello ");
    expect(ast[1].type, Type.Argument);
    expect(ast[1].value, "name");
    expect(ast[2].value, "!");
  });

  test('Test parameter can only start with letter', () {
    final parser = ICUParser();
    expect(() => parser.parse("{1foo}"), throwsArgumentError);
  });

  test('Test parse support escape', () {
    final parser = ICUParser();
    final ast = parser.parse("This '{isn''t}' obvious");
    expect(ast[0].value, "This {isn't} obvious");
  });

  test('Test parse select message', () {
    final parser = ICUParser();
    final ast = parser.parse("100 {currency, select, TWD{NT} HKD{HK} other{\$}}");

    expect(ast[0].value, "100 ");
    expect(ast[1].type, Type.Select);
    expect(ast[1].value, "currency");
    expect(ast[1].options.keys, ["TWD", "HKD", "other"]);
    final values = ast[1].options.values.toList();
    expect(values[0][0].value, "NT");
    expect(values[1][0].value, "HK");
    expect(values[2][0].value, "\$");
  });

  test('Test parse gender message', () {
    final parser = ICUParser();
    final ast = parser.parse("{gender, gender, female{female} male{male} other{other}}");
    expect(ast[0].value, "gender");
    expect(ast[0].type, Type.Gender);
    expect(ast[0].options.keys, ["female", "male", "other"]);
    final values = ast[0].options.values.toList();
    expect(values[0][0].value, "female");
    expect(values[1][0].value, "male");
    expect(values[2][0].value, "other");
  });

  test('Test parse plural message', () {
    final parser = ICUParser();
    final ast = parser.parse("{count, plural, =0{no reply} =1{1 reply} other{# replies}}");
    expect(ast[0].value, "count");
    expect(ast[0].type, Type.Plural);
    expect(ast[0].options.keys, ["=0", "=1", "other"]);
    final values = ast[0].options.values.toList();
    expect(values[0][0].value, "no reply");
    expect(values[1][0].value, "1 reply");
    expect(values[2][0].type, Type.HashTag);
    expect(values[2][1].value, " replies");
  });

  test('Test nested message', () {
    final parser = ICUParser();
    final ast = parser.parse(
      """{gender_of_host, select,
        female {{num_guests, plural,
            =0 {{host} doest not give a party.}
            =1 {{host} invites {guest} to her party.}
            =2 {{host} invites {guest} and one other person to her party.}
            other {{host} invites {guest} and # other people to her party.}}}}"""
    );

    expect(ast[0].type, Type.Select);
    expect(ast[0].value, "gender_of_host");
    expect(ast[0].options.keys, ["female"]);

    final values = ast[0].options.values.toList();
    expect(values[0][0].type, Type.Plural);
    expect(values[0][0].value, "num_guests");
    expect(values[0][0].options.keys, ["=0", "=1", "=2", "other"]);
    final option0Values = values[0][0].options.values.toList();
    expect(option0Values[0][0].type, Type.Argument);
    expect(option0Values[0][0].value, "host");
    expect(option0Values[0][1].value, " doest not give a party.");
    expect(option0Values[1][0].type, Type.Argument);
    expect(option0Values[1][0].value, "host");
    expect(option0Values[1][1].value, " invites ");
    expect(option0Values[1][2].type, Type.Argument);
    expect(option0Values[1][2].value, "guest");
    expect(option0Values[1][3].value, " to her party.");
    expect(option0Values[2][0].type, Type.Argument);
    expect(option0Values[2][0].value, "host");
    expect(option0Values[2][1].value, " invites ");
    expect(option0Values[2][2].type, Type.Argument);
    expect(option0Values[2][2].value, "guest");
    expect(option0Values[2][3].value, " and one other person to her party.");
    expect(option0Values[3][0].type, Type.Argument);
    expect(option0Values[3][0].value, "host");
    expect(option0Values[3][1].value, " invites ");
    expect(option0Values[3][2].type, Type.Argument);
    expect(option0Values[3][2].value, "guest");
    expect(option0Values[3][3].value, " and ");
    expect(option0Values[3][4].type, Type.HashTag);
    expect(option0Values[3][5].value, " other people to her party.");
  });
}
