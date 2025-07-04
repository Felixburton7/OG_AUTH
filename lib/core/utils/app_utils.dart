import 'package:intl/intl.dart';

/// Utility class for common functions used throughout the app
class AppUtils {
  /// Converts a decimal multiplier to a reduced fraction string.
  static String decimalToFraction(double value) {
    // Check for whole numbers
    if (value == value.toInt()) {
      return "${value.toInt()}/1";
    }

    // Maximum denominator for reasonable fraction display
    const int maxDenominator = 100;

    // Find the best fraction approximation
    double epsilon = 1.0e-6;
    double bestError = double.infinity;
    int bestNumerator = 0;
    int bestDenominator = 1;

    for (int denominator = 1; denominator <= maxDenominator; denominator++) {
      int numerator = (value * denominator).round();
      double error = (numerator / denominator - value).abs();

      if (error < bestError) {
        bestError = error;
        bestNumerator = numerator;
        bestDenominator = denominator;
      }

      // If we're close enough, stop searching
      if (error < epsilon) {
        break;
      }
    }

    // Further reduce the fraction by finding the greatest common divisor
    int gcd = _gcd(bestNumerator, bestDenominator);
    return "${bestNumerator ~/ gcd}/${bestDenominator ~/ gcd}";
  }

  /// Calculates the greatest common divisor of two integers
  static int _gcd(int a, int b) {
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// Formats date as "EEEE, MMM d"
  static String formatDay(DateTime dt) =>
      DateFormat('EEEE, MMM d').format(dt.toLocal());

  /// Formats fixture time with relative context (Today, Tomorrow, or date)
  static String formatFixtureTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final fixtureDate = DateTime(dt.year, dt.month, dt.day);
    final formattedTime = DateFormat.Hm().format(dt);

    if (fixtureDate == today) {
      return "Today, $formattedTime";
    } else if (fixtureDate == tomorrow) {
      return "Tomorrow, $formattedTime";
    } else {
      return "${DateFormat('d MMM').format(dt).toUpperCase()}, $formattedTime";
    }
  }

  /// Returns a readable money string with currency symbol
  static String formatCurrency(double amount,
      {String symbol = '£', int decimals = 2}) {
    return "$symbol${amount.toStringAsFixed(decimals)}";
  }

  /// Calculate potential returns from a bet
  static double calculateReturns(double stake, double odds) {
    // Adding 1.0 to odds if it's already in decimal format without the 1.0 base
    return stake * odds;
  }
}
