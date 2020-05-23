import 'dart:io';

import 'package:localization_generator/main.dart';
import 'package:test/test.dart';

String currentFolder(String path) {
  return Directory.current.path + '/test$path';
}

void main() {
  test('Test can generate localization file', () {
    final l10nDir = Directory(currentFolder('/l10n'));
    final outputDir = Directory(currentFolder('/generated'));
    doGenerate(l10nDir, outputDir);
    expect(
      File(currentFolder('/generated/localization.dart')).readAsStringSync(),
      File(currentFolder('/generated/localization_snapshot.dart'))
          .readAsStringSync(),
    );
  });
}
