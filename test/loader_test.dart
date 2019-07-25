import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:localization_generator/loader.dart';

void main() {
  test('Test loader can load the json file', () {
    String testingFolder = Directory.current.path + '/i18n';
    final loader = JSONLoader(testingFolder);
    const expectedFiles = ['en.json', 'zh.json'];
    var filesCount = 0;
    loader.onLoaded((filename, json) {
      expect(expectedFiles.contains(filename), true);
      filesCount++;
    });
    loader.load();
    expect(filesCount, 2);
  });

  test('Test loader throw error when folder do not exists', () {
    expect(() => JSONLoader('some folder'), throwsException);
  });

  test('Test loader throw error when folder do not exists', () {
    String testingFolder = Directory.current.path + '/wrong_i18n';
    final loader = JSONLoader(testingFolder);
    loader.onLoaded((filename, json) {});
    expect(() => loader.load(), throwsException);
  });
}
