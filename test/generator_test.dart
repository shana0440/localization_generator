import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:localization_generator/generator.dart';

void main() {
  test('Test generator can generate the Localization file', () {
    String testingOutputFolder = Directory.current.path + '/generated';
    final generator = Generator(testingOutputFolder);
    var enJSON = jsonDecode('''
      {
        "PackageTitle": "Localization Generator",
        "PackageDescription": "Use to generate localization code from json file",
        "ArgumentTest": "from {{start}} to {{end}}",
        "BreakLine": "break\\nline"
      }
      ''');
    var zhJSON = jsonDecode('''
      {
          "PackageTitle": "多國語系產生器",
          "PackageDescription": "從json檔案產出多國語系的程式",
          "ArgumentTest": "從 {{start}} 到 {{end}}",
          "BreakLine": "斷\\n行"
      }
      ''');
    generator.load('en_US', enJSON);
    generator.load('zh_Hant', zhJSON);
    generator.generate();
    expect(
      File('./generated/localization.dart').readAsStringSync(),
      File('./generated/localization_snapshot.dart').readAsStringSync(),
    );
  });
}
