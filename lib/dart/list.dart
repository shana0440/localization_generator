extension ListExtension on List {
  Iterable<T> distinct<T>() {
    return Set<T>.from(this).toList();
  }
}