import 'dart:io';

import 'package:test/test.dart';

import 'package:localization_generator/loader/json_loader.dart';

String currentFolder(String path) {
  return Directory.current.path + '/test/loader$path';
}

void main() {
  test('Test loader can load the json and get the locale', () {
    String testingFolder = currentFolder('/l10n');
    final loader = JSONLoader();
    final result = loader.load(Directory(testingFolder));
    final locales = result.map((it) => it.locale).toList();
    expect(result.length, 2);
    expect(locales, ['en_US', 'zh_Hant']);
  });

  test('Test loader will throw error if dir not exists', () {
    String testingFolder = currentFolder('/no_exist');
    final loader = JSONLoader();
    expect(() => loader.load(Directory(testingFolder)), throwsArgumentError);
  });

  test('Test loader will throw error if value not string', () {
    String testingFolder = currentFolder('/invalid_json_l10n');
    final loader = JSONLoader();
    expect(() {
      loader.load(Directory(testingFolder));
    }, throwsArgumentError);
  });
}
