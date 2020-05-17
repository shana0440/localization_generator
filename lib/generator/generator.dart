import 'package:localization_generator/parser/parser.dart';

abstract class Generator {
  String generate(String key, List<Node> ats);
}
