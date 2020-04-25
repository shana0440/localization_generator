library localization_generator;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

typedef OnJSONLoadedListener = Function(String filename, dynamic json);

class LoadDirectoryError implements Exception {
  final String message;

  LoadDirectoryError({this.message});
}

class JSONLoader {
  Directory inputDir;
  OnJSONLoadedListener onLoadedListener;

  JSONLoader(String input) {
    this.inputDir = Directory(input);
    if (!this.inputDir.existsSync()) {
      throw LoadDirectoryError(message: "$input is not exists");
    }
  }

  void load() {
    if (onLoadedListener != null) {
      final files = this
          .inputDir
          .listSync(recursive: false)
          .where((it) => it.path.endsWith(".json"));
      for (var file in files) {
        final content = (file as File).readAsStringSync();
        final json = jsonDecode(content);
        onLoadedListener(basename(file.path), json);
      }
    }
  }

  void onLoaded(OnJSONLoadedListener onLoadedListener) {
    this.onLoadedListener = onLoadedListener;
  }
}
