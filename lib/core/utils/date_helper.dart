import 'package:intl/intl.dart'; // For date formatting

class DateHelper {
  /// Formats a given DateTime to "DayName Month DaySuffix" (e.g., "Thursday October 5th")
  static String getFormattedDate(DateTime date) {
    final dayName = DateFormat('EEEE').format(date); // Get day name
    final day = date.day;
    final month = DateFormat('MMMM').format(date); // Get month name
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    return '$dayName $month $day$suffix';
  }
}
