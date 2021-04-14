import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'loader.dart';

class JSONLoader implements Loader {
  @override
  List<Record> load(Directory dir) {
    if (!dir.existsSync()) {
      throw ArgumentError('The dir $dir not found');
    }
    final files = dir
        .listSync(recursive: false)
        .where((it) => it.path.endsWith('.json'))
        .cast<File>();
    return files.map((it) {
      final json = _decode(it);
      return Record(
        basenameWithoutExtension(it.path),
        json,
      );
    }).toList()
      ..sort((a, b) => a.locale.compareTo(b.locale));
  }

  Map<String, String> _decode(File file) {
    final content = file.readAsStringSync();
    final json = jsonDecode(content) as Map<String, dynamic>;
    for (var entry in json.entries) {
      if (entry.value is! String) {
        throw ArgumentError(
          'The value of key `${entry.key}` must be string, but is ${entry.value}',
        );
      }
    }
    return json.cast<String, String>();
  }
}
