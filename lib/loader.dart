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
  Directory input;
  OnJSONLoadedListener onLoadedListener;

  JSONLoader(String input) {
    this.input = Directory(input);
    if (!this.input.existsSync()) {
      throw LoadDirectoryError(message: "$input is not exists");
    }
  }

  void load() {
    if (this.onLoadedListener is OnJSONLoadedListener) {
      final files = this
          .input
          .listSync(recursive: false)
          .where((it) => it.path.endsWith(".json"));
      for (var file in files) {
        var content = (file as File).readAsStringSync();
        var json = jsonDecode(content);
        this.onLoadedListener(basename(file.path), json);
      }
    }
  }

  void onLoaded(OnJSONLoadedListener onLoadedListener) {
    this.onLoadedListener = onLoadedListener;
  }
}
