enum Type { Message, Select, Plural, Gender, Argument, HashTag }

class Node {
  final Type type;
  final Map<String, List<Node>> options;
  final String value;

  Node({this.type, this.options, this.value});

  @override
  String toString() {
    return "$type, $value, ${options}";
  }
}

abstract class Parser {
  List<Node> parse(String value);
}