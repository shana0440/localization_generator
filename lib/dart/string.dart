extension StringExtensions on String {
  String indent(int length) {
    return this.split("\n").map((it) => " " * length + it).join("\n");
  }
}
