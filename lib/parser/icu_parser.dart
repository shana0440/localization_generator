import 'package:localization_generator/parser/parser.dart';
import 'package:localization_generator/parser/token.dart';

class ICUParser implements Parser {
  int _offset = 0;
  String _value = "";

  final _openCurly = Str('{');
  final _closeCurly = Str('}');
  final _letter = Letter();
  final _digits = Digits();
  final _underline = Str('_');
  final _singleQuote = Str("'");
  final _doubleSingleQuote = Str("''");
  final _comma = Str(',');
  final _select = Str('select');
  final _gender = Str('gender');
  final _plural = Str('plural');
  final _hashtag = Str('#');

  @override
  List<Node> parse(String value) {
    _value = value;
    _offset = 0;
    return _doParse();
  }

  List<Node> _doParse() {
    final List<Node> nodes = [];
    String message = "";
    bool isEscaping = false;

    void addMessageToNodes(String message) {
      if (message != "") {
        nodes.add(Node(
          type: Type.Message,
          value: message,
        ));
      }
    }

    // stop when reach end, or reach close curly if not escaping
    while (!_reachEnd && (isEscaping || !_predict(_closeCurly))) {
      if (_predict(_singleQuote) && !_predict(_doubleSingleQuote)) {
        _take(); // take away single quote
        isEscaping = !isEscaping;
      }

      if (_predict(_openCurly) && !isEscaping) {
        addMessageToNodes(message);
        message = "";

        _take();
        nodes.add(_or([
          _parseArgument,
          _parseSelect,
          _parseGender,
          _parsePlural,
        ]));
      } else if (_predict(_hashtag) && !isEscaping) {
        addMessageToNodes(message);
        message = "";

        _take();
        nodes.add(Node(type: Type.HashTag));
      } else {
        if (_predict(_doubleSingleQuote)) {
          _take(); // take away single quote
        }
        message += _take();
      }
    }

    if (message != "") {
      nodes.add(Node(
        value: message,
        type: Type.Message,
      ));
    }

    if (_predict(_closeCurly)) {
      _take();
    }

    return nodes;
  }

  Node _parseArgument() {
    String argument = "";
    if (!_predict(_letter)) {
      throw ArgumentError('Argument can only start with letter');
    }

    while (!_reachEnd && !_predict(_closeCurly)) {
      final isValidArgument =
          _predict(_letter) || _predict(_digits) || _predict(_underline);
      if (isValidArgument) {
        final took = _take();
        // get argument name
        argument += took;
      } else {
        throw ArgumentError('Argument should compose by letter, _ or digits.');
      }
    }

    if (_predict(_closeCurly)) {
      _take();
      return Node(
        value: argument,
        type: Type.Argument,
      );
    }

    throw ArgumentError('Need }');
  }

  Node _parseSelect() {
    final argument = _takeUntil(_comma);
    if (!_select.isOk(_takeUntil(_comma))) {
      throw ArgumentError('Only support select, plural, gender');
    }
    final options = _parseOptions();
    return Node(
      type: Type.Select,
      value: argument,
      options: options,
    );
  }

  Node _parseGender() {
    final argument = _takeUntil(_comma);
    if (!_gender.isOk(_takeUntil(_comma))) {
      throw ArgumentError('Only support select, plural, gender');
    }
    final options = _parseOptions(['female', 'male', 'other']);
    return Node(
      type: Type.Gender,
      value: argument,
      options: options,
    );
  }

  Node _parsePlural() {
    final argument = _takeUntil(_comma);
    if (!_plural.isOk(_takeUntil(_comma))) {
      throw ArgumentError('Only support select, plural, gender');
    }
    final options = _parseOptions(
      ['=0', '=1', '=2', 'zero', 'one', 'two', 'few', 'many', 'other'],
    );
    return Node(
      type: Type.Plural,
      value: argument,
      options: options,
    );
  }

  Map<String, List<Node>> _parseOptions([List<String>? allowValue]) {
    final Map<String, List<Node>> options = {};
    while (!_reachEnd && !_predict(_closeCurly)) {
      String value = "";
      while (!_reachEnd && !_predict(_openCurly)) {
        final took = _take();
        value += took;
      }
      if (allowValue != null && !allowValue.contains(value.trim())) {
        throw ArgumentError('$value is not valid option');
      }
      if (_predict(_openCurly)) {
        _take();
        final metadata = _doParse();
        options[value.trim()] = metadata;
        continue;
      }

      if (_reachEnd) {
        throw ArgumentError('Need {');
      }
    }

    if (_predict(_closeCurly)) {
      _take();
      return options;
    }
    throw ArgumentError('Need }');
  }

  Node _or(List<Node Function()> parsers) {
    final errors = [];
    final offset = _offset;
    for (final parser in parsers) {
      try {
        return parser.call();
      } catch (e) {
        errors.add(e);
        _offset = offset;
      }
    }
    throw errors.last;
  }

  bool _predict(TokenType token) {
    if (_offset + token.length > _value.length) {
      return false;
    }
    final tk = _value.substring(_offset, _offset + token.length);
    return token.isOk(tk);
  }

  String _take() {
    final value = _value[_offset];
    _offset += 1;
    return value;
  }

  String _takeUntil(TokenType token) {
    String took = "";
    while (!_predict(token)) {
      took += _take();
    }
    _take(); // take token
    return took;
  }

  bool get _reachEnd {
    if (_offset >= _value.length) {
      return true;
    }
    return false;
  }

  int get offset => _offset;
}
