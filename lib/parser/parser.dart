enum Type { Message, Select, Plural, Gender, Argument, HashTag }

abstract class Node {
  final Type type;
  final Map<String, List<Node>> options;
  final String? value;

  const Node({
    required this.type,
    this.options = const <String, List<Node>>{},
    this.value,
  });

  @override
  String toString() {
    return "$type, $value, $options";
  }
}

abstract class Parser {
  List<Node> parse(String value);
}

class MessageNode extends Node {
  MessageNode(String message) : super(type: Type.Message, value: message);
}

class SelectNode extends Node {
  SelectNode(String argument, Map<String, List<Node>> options)
      : super(type: Type.Select, value: argument, options: options);
}

class PluralNode extends Node {
  PluralNode(String argument, Map<String, List<Node>> options)
      : super(type: Type.Plural, value: argument, options: options);
}

class GenderNode extends Node {
  GenderNode(String argument, Map<String, List<Node>> options)
      : super(type: Type.Gender, value: argument, options: options);
}

class ArgumentNode extends Node {
  ArgumentNode(String? argument) : super(type: Type.Argument, value: argument);
}

class HashTagNode extends Node {
  HashTagNode() : super(type: Type.HashTag);
}
