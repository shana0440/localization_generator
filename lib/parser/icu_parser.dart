import 'package:localization_generator/exceptions/invalid_argument_exception.dart';
import 'package:localization_generator/exceptions/invalid_choice_exception.dart';
import 'package:localization_generator/exceptions/invalid_option_exception.dart';
import 'package:localization_generator/exceptions/missing_close_curly_exception.dart';
import 'package:localization_generator/exceptions/missing_open_curly_exception.dart';
import 'package:localization_generator/exceptions/reach_end_exception.dart';
import 'package:localization_generator/parser/parser.dart';
import 'package:localization_generator/parser/token.dart';

class State {}

class PluralState extends State {
  String argument;
  PluralState(this.argument);
}

class ICUParser implements Parser {
  int _offset = 0;
  String _value = "";

  final _openCurly = Str('{');
  final _closeCurly = Str('}');
  final _singleQuote = Str("'");
  final _doubleSingleQuote = Str("''");
  final _comma = Str(',');
  final _select = Str('select');
  final _gender = Str('gender');
  final _plural = Str('plural');
  final _hashtag = Str('#');
  final _validArgumentRegex = RegExp(r"^[a-zA-Z]\w*");

  @override
  List<Node> parse(String value) {
    _value = value;
    _offset = 0;
    return _doParse();
  }

  List<Node> _doParse([State? state, TokenType? endAt]) {
    final List<Node> nodes = [];
    bool isEscaping = false;

    String message = "";
    void addMessageNode() {
      if (message != "") {
        nodes.add(MessageNode(message));
      }
      message = "";
    }

    while (!_reachEnd && (endAt == null || !_predict(endAt))) {
      if (_predict(_singleQuote) &&
          !_predict(_doubleSingleQuote, falseWhenReachEnd: true)) {
        isEscaping = !isEscaping;
      }

      if (_predict(_openCurly, takeAwayWhenPredicted: true) && !isEscaping) {
        addMessageNode();

        String argument = "";
        try {
          argument = _takeUntil([_comma, _closeCurly]);
          if (!_validArgumentRegex.hasMatch(argument)) {
            throw InvalidArgumentException();
          }
        } on ReachEndException {
          throw MissingCloseCurlyException();
        }

        if (_predict(_closeCurly, takeAwayWhenPredicted: true)) {
          nodes.add(ArgumentNode(argument));
          continue;
        }

        if (_predict(_comma, takeAwayWhenPredicted: true)) {
          try {
            String choice = _takeUntil([_comma]);
            _take(); // take away comma
            if (_select.isOk(choice)) {
              final options = _parseOptions();
              nodes.add(SelectNode(argument, options));
            } else if (_plural.isOk(choice)) {
              final options = _parseOptions(
                  state: PluralState(argument),
                  allowValue: [
                    '=0',
                    '=1',
                    '=2',
                    'zero',
                    'one',
                    'two',
                    'few',
                    'many',
                    'other'
                  ]);
              nodes.add(PluralNode(argument, options));
            } else if (_gender.isOk(choice)) {
              final options =
                  _parseOptions(allowValue: ['female', 'male', 'other']);
              nodes.add(GenderNode(argument, options));
            } else {
              throw InvalidChoiceException();
            }
          } on ReachEndException {
            throw InvalidChoiceException();
          }
        }
        if (!_predict(_closeCurly, takeAwayWhenPredicted: true)) {
          throw MissingCloseCurlyException();
        }
      } else if (state is PluralState &&
          _predict(_hashtag, takeAwayWhenPredicted: true) &&
          !isEscaping) {
        addMessageNode();
        nodes.add(ArgumentNode(state.argument));
      } else {
        _predict(_singleQuote,
            falseWhenReachEnd: true, takeAwayWhenPredicted: true);
        if (_predict(_closeCurly, falseWhenReachEnd: true) && !isEscaping) {
          throw MissingOpenCurlyException();
        }
        // FIXME: keep exit loop condition in one place
        if (!_reachEnd && (endAt == null || !_predict(endAt))) {
          message += _take();
        }
      }
    }
    addMessageNode();

    return nodes;
  }

  Map<String, List<Node>> _parseOptions(
      {State? state, List<String>? allowValue}) {
    final Map<String, List<Node>> options = {};
    while (!_predict(_closeCurly)) {
      String value = _takeUntil([_openCurly]);
      _take(); // take away open curly
      if (allowValue != null && !allowValue.contains(value.trim())) {
        throw InvalidOptionException(allowValue, value);
      }
      if (_reachEnd) {
        throw MissingOpenCurlyException();
      }

      final metadata = _doParse(state, _closeCurly);
      _take(); // take away close curly
      options[value.trim()] = metadata;
      continue;
    }
    return options;
  }

  bool _predict(TokenType token,
      {bool falseWhenReachEnd = false, takeAwayWhenPredicted: false}) {
    if ((_offset + token.length) > _value.length) {
      if (falseWhenReachEnd) {
        return false;
      }
      throw ReachEndException();
    }
    final tk = _value.substring(_offset, _offset + token.length);
    final ok = token.isOk(tk);
    if (takeAwayWhenPredicted && ok) {
      _take();
    }
    return ok;
  }

  String _take() {
    if (_reachEnd) {
      throw ReachEndException();
    }
    final value = _value[_offset];
    _offset += 1;
    return value;
  }

  String _takeUntil(List<TokenType> tokens) {
    String took = "";
    while (!tokens.any((it) => _predict(it))) {
      took += _take();
    }
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
