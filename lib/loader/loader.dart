import 'dart:io';

class Record {
  final String locale;
  final Map<String, String> records;

  Record(this.locale, this.records);
}

abstract class Loader {
  List<Record> load(Directory dir);
}
