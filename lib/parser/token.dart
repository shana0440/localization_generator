abstract class TokenType {
  bool isOk(String value);

  int get length;
}

class Str extends TokenType {
  final String _string;

  Str(this._string);

  @override
  bool isOk(String value) {
    return _string.trim() == value.trim();
  }

  @override
  int get length => _string.length;
}

class Letter extends TokenType {
  @override
  bool isOk(String value) {
    return 'abcdefghijklmnopqrstuvwxyz'.contains(value.toLowerCase());
  }

  @override
  int get length => 1;
}

class Digits extends TokenType {
  @override
  bool isOk(String value) {
    return '0123456789'.contains(value.toLowerCase());
  }

  @override
  int get length => 1;
}