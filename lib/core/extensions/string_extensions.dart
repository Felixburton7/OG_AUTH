// This extension adds a utility method to nullable String types.
extension NullableStringExtension on String? {
  // Getter to check if the string is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

// This extension adds utility methods to the String class.
extension StringExtensions on String {
  // Method to capitalize the first letter of the string.
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
