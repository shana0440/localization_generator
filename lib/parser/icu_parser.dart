import 'package:localization_generator/exceptions/invalid_argument_exception.dart';
import 'package:localization_generator/exceptions/invalid_choice_exception.dart';
import 'package:localization_generator/exceptions/invalid_option_exception.dart';
import 'package:localization_generator/exceptions/missing_close_curly_exception.dart';
import 'package:localization_generator/exceptions/missing_open_curly_exception.dart';
import 'package:localization_generator/parser/parser.dart';
import 'package:localization_generator/parser/token.dart';

enum State { Message, Plural, Select, Gender }

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
    return _doParse(State.Message);
  }

  List<Node> _doParse(State state) {
    final List<Node> nodes = [];
    String message = "";
    bool isEscaping = false;

    void addMessageNode(String message) {
      if (message != "") {
        nodes.add(MessageNode(message));
      }
    }

    // stop when reach end, or reach close curly if not escaping
    while (!_reachEnd && (isEscaping || !_predict(_closeCurly))) {
      if (_predict(_singleQuote) && !_predict(_doubleSingleQuote)) {
        _take(); // take away single quote
        isEscaping = !isEscaping;
      }

      if (_predict(_openCurly) && !isEscaping) {
        addMessageNode(message);
        message = "";

        _take();
        nodes.add(_or([
          _parseArgument,
          _parseSelect,
          _parseGender,
          _parsePlural,
        ]));
      } else if (_predict(_hashtag) && !isEscaping && state == State.Plural) {
        addMessageNode(message);
        message = "";

        _take();
        nodes.add(HashTagNode());
      } else {
        if (_predict(_doubleSingleQuote)) {
          _take(); // take away single quote
        }
        if (!_reachEnd) {
          message += _take();
        }
      }
    }

    addMessageNode(message);

    if (_predict(_closeCurly)) {
      _take();
    }

    return nodes;
  }

  Node _parseArgument() {
    String argument = "";
    if (!_predict(_letter)) {
      throw InvalidArgumentException();
    }

    while (!_reachEnd && !_predict(_closeCurly)) {
      final isValidArgument =
          _predict(_letter) || _predict(_digits) || _predict(_underline);
      if (isValidArgument) {
        final took = _take();
        // get argument name
        argument += took;
      } else {
        throw InvalidArgumentException();
      }
    }

    if (_predict(_closeCurly)) {
      _take();
      return ArgumentNode(argument);
    }

    throw MissingCloseCurlyException();
  }

  Node _parseSelect() {
    final argument = _takeUntil(_comma);
    if (!_select.isOk(_takeUntil(_comma))) {
      throw InvalidChoiceException();
    }
    final options = _parseOptions(State.Select);
    return SelectNode(argument, options);
  }

  Node _parseGender() {
    final argument = _takeUntil(_comma);
    if (!_gender.isOk(_takeUntil(_comma))) {
      throw InvalidChoiceException();
    }
    final options = _parseOptions(State.Gender, ['female', 'male', 'other']);
    return GenderNode(argument, options);
  }

  Node _parsePlural() {
    final argument = _takeUntil(_comma);
    if (!_plural.isOk(_takeUntil(_comma))) {
      throw InvalidChoiceException();
    }
    final options = _parseOptions(
      State.Plural,
      ['=0', '=1', '=2', 'zero', 'one', 'two', 'few', 'many', 'other'],
    );
    return PluralNode(argument, options);
  }

  Map<String, List<Node>> _parseOptions(State state,
      [List<String>? allowValue]) {
    final Map<String, List<Node>> options = {};
    while (!_reachEnd && !_predict(_closeCurly)) {
      String value = "";
      while (!_reachEnd && !_predict(_openCurly)) {
        final took = _take();
        value += took;
      }
      if (allowValue != null && !allowValue.contains(value.trim())) {
        throw InvalidOptionException(allowValue, value);
      }
      if (_predict(_openCurly)) {
        _take();
        final metadata = _doParse(state);
        options[value.trim()] = metadata;
        continue;
      }

      if (_reachEnd) {
        throw MissingOpenCurlyException();
      }
    }

    if (_predict(_closeCurly)) {
      _take();
      return options;
    }
    throw MissingCloseCurlyException();
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
