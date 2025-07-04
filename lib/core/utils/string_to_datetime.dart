// date_utils.dart
import 'package:intl/intl.dart';

DateTime? parseDateTime(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return null; // Return null if the string is null or empty
  }
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    // Handle the exception if the date string is invalid (optional)
    return null;
  }
}

String parseDateTimeToString(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }
  return dateTime.toIso8601String();
}

// Function to format the DateTime to MM/dd format
String formatDate(DateTime? date) {
  if (date == null) return '';
  final DateFormat formatter = DateFormat('MM/dd');
  return formatter.format(date);
}
