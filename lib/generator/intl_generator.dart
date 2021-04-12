import 'package:localization_generator/dart/list.dart';
import 'package:localization_generator/generator/generator.dart';
import 'package:localization_generator/parser/parser.dart';

class IntlGenerator extends Generator {
  final List<String> _arguments = [];

  @override
  String generate(String key, List<Node> ats) {
    _arguments.clear();
    final msg = _convertATS(ats);
    if (_arguments.isEmpty) {
      return """String get $key => $msg""";
    } else {
      final arguments =
          _arguments.distinct().map((it) => "dynamic $it").join(", ");
      return """String $key({$arguments}) => $msg""";
    }
  }

  String _convertATS(List<Node> ats, {String? pluralHashTagVariable}) {
    final List<Node> nodes = [];
    final List<String?> messages = [];
    for (final node in ats) {
      if (node is SelectNode) {
        messages.add(_convertMessage(nodes));
        nodes.clear();
        messages.add(_convertSelect(node));
      } else if (node is GenderNode) {
        messages.add(_convertMessage(nodes));
        nodes.clear();
        messages.add(_convertGender(node));
      } else if (node is PluralNode) {
        messages.add(_convertMessage(nodes));
        nodes.clear();
        messages.add(_convertPlural(node));
      } else if (node is ArgumentNode || node is MessageNode) {
        nodes.add(node);
      } else if (node is HashTagNode) {
        nodes.add(ArgumentNode(pluralHashTagVariable));
      }
    }
    messages.add(_convertMessage(nodes));

    return messages.where((it) => it != null).join(" + ");
  }

  String? _convertMessage(List<Node> ats) {
    if (ats.isEmpty) return null;
    String msg = "";
    for (final node in ats) {
      if (node is MessageNode) {
        msg += node.value!;
      }
      if (node is ArgumentNode) {
        _arguments.add(node.value!);
        msg += "\$${node.value}";
      }
    }
    return """Intl.message("$msg")""";
  }

  String _convertSelect(Node node) {
    _arguments.add(node.value!);
    final options = node.options.entries
        .fold<Map<String, String>>({}, (acc, entry) {
          acc[entry.key] = _convertATS(entry.value);
          return acc;
        })
        .entries
        .fold<List<String>>([], (acc, entry) {
          acc.add('"${entry.key}": ${entry.value}');
          return acc;
        })
        .join(", ");

    return """Intl.select(${node.value}, {$options})""";
  }

  String _convertGender(Node node) {
    _arguments.add(node.value!);
    final List<String> options = [];
    if (node.options.containsKey('female')) {
      options.add('female: ${_convertATS(node.options['female']!)}');
    }
    if (node.options.containsKey('male')) {
      options.add('male: ${_convertATS(node.options['male']!)}');
    }
    if (node.options.containsKey('other')) {
      options.add('other: ${_convertATS(node.options['other']!)}');
    }
    return """Intl.gender(${node.value}, ${options.join(", ")})""";
  }

  String _convertPlural(Node node) {
    _arguments.add(node.value!);
    final List<String> options = [];
    if (node.options.containsKey('=0') || node.options.containsKey('zero')) {
      options.add(
        'zero: ${_convertATS(
          node.options['=0'] ?? node.options['zero']!,
          pluralHashTagVariable: node.value,
        )}',
      );
    }
    if (node.options.containsKey('=1') || node.options.containsKey('one')) {
      options.add(
        'one: ${_convertATS(
          node.options['=1'] ?? node.options['one']!,
          pluralHashTagVariable: node.value,
        )}',
      );
    }
    if (node.options.containsKey('=2') || node.options.containsKey('two')) {
      options.add(
        'two: ${_convertATS(
          node.options['=2'] ?? node.options['two']!,
          pluralHashTagVariable: node.value,
        )}',
      );
    }
    if (node.options.containsKey('few')) {
      options.add('few: ${_convertATS(
        node.options['few']!,
        pluralHashTagVariable: node.value,
      )}');
    }
    if (node.options.containsKey('many')) {
      options.add('many: ${_convertATS(
        node.options['many']!,
        pluralHashTagVariable: node.value,
      )}');
    }
    if (node.options.containsKey('other')) {
      options.add('other: ${_convertATS(
        node.options['other']!,
        pluralHashTagVariable: node.value,
      )}');
    }
    return """Intl.plural(${node.value}, ${options.join(", ")})""";
  }
}
