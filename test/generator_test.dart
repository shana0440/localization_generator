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
        "PackageDescription": "Use to generate localization code from json file"
      }
      ''');
    var zhJSON = jsonDecode('''
      {
          "PackageTitle": "多國語系產生器",
          "PackageDescription": "從json檔案產出多國語系的程式"
      }
      ''');
    generator.load('en', enJSON);
    generator.load('zh', zhJSON);
    generator.generate();
    expect(File('./generated/localization.dart').readAsStringSync(),
        File('./generated/localization_snapshot.dart').readAsStringSync());
  });
}
