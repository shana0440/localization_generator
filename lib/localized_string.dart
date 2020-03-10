class LocalizedString {
  final String key;
  final String value;

  LocalizedString.fromKeyValue(this.key, this.value);

  List<String> _findArgs(String value) {
    final exp = RegExp(r"{{(\w+)}}");
    final matches = exp.allMatches(value);
    final argNames =
        matches.map((it) => it.group(0).replaceAll(RegExp(r"{|}"), ""));
    return argNames.toList();
  }

  String _replaceArgs(String value) {
    final exp = RegExp(r"{{(\w+)}}");
    final matches = exp.allMatches(value);

    return matches.map((it) {
      return MapEntry(it.group(0), it.group(0).replaceAll(RegExp(r"{|}"), ""));
    }).fold(value, (acc, it) {
      return acc.replaceFirst(it.key, "\$${it.value}");
    });
  }

  String get toGetter {
    final args = _findArgs(value);
    if (args.isEmpty) {
      return 'String get $key => "$value";';
    }
    final argsString = args.map((it) => "String $it").join(", ");
    return 'String $key($argsString) => "${_replaceArgs(value)}";';
  }
}
