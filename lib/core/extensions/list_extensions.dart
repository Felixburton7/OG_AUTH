// This extension adds utility methods to the List class, making it easier to work with lists.
extension ExtensionList<T> on List<T> {
  // Getter to retrieve the last item in the list.
  T get lastItem => this[length - 1];

  // Getter to create a reversed copy of the list.
  List<T> get reversedCopy => reversed.toList();
}
