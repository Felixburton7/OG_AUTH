import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panna_app/core/constants/spacings.dart';

final theme = _getLightTheme(_lightColorScheme); // Light mode theme
final darkTheme = _getDarkTheme(_darkColorScheme); // Dark mode theme

// Light Color Scheme
final _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF053326), // Button background and icon color
    onPrimary: Colors.white, // Text on primary button
    secondary: Color(0xFF053326),
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    background: Color.fromARGB(255, 239, 240, 240), // Background color
    onBackground: Colors.black, // Text on background
    surface: Color.fromARGB(255, 239, 240, 240), // Surface color
    onSurface: Colors.black, // Text on surface
    tertiary: Colors.black);

// Dark Color Scheme
final _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFE6E8E8), // Button background
    onPrimary: Color.fromARGB(255, 27, 27, 27), // Text on primary button
    secondary: Color.fromRGBO(208, 248, 18, 1), // Icon color
    onSecondary: Color(0xFF053326),
    error: Colors.red,
    onError: Colors.white,
    background: Color.fromARGB(255, 27, 27, 27), // Background color
    onBackground: Color(0xFFE6E8E8), // Text on background
    surface: Color.fromARGB(255, 27, 27, 27), // Surface color
    onSurface: Color(0xFFE6E8E8), // Text on surface
    tertiary: Colors.black);

// Logo Paths
class AppThemeAssets {
  static const String lightLogo = 'assets/images/pannaLogoLight.png';
  static const String darkLogo = 'assets/images/pannaLogoDark.png';
  static const String lmsAbrevLight = 'assets/images/lmsAbrevLight.png';
  static const String lmsAbrevDark = 'assets/images/lmsAbrevDark.png';
  static const String lmsLight = 'assets/images/lmsLight.png';
  static const String lmsDark = 'assets/images/lmsDark.png';
}

// Light Mode Theme
ThemeData _getLightTheme(ColorScheme colorScheme) {
  final textTheme = _getTextTheme(colorScheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: IconThemeData(
        color: colorScheme.primary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.s16),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.s16,
          horizontal: Spacing.s32,
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.background,
      indicatorColor: colorScheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(Spacing.s24),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.s16),
      ),
    ),
  );
}

// Dark Mode Theme
ThemeData _getDarkTheme(ColorScheme colorScheme) {
  final textTheme = _getTextTheme(colorScheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: IconThemeData(
        color: colorScheme.secondary, // Icon color
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacing.s16),
        ),
        backgroundColor: colorScheme.primary, // Button background
        foregroundColor: colorScheme.onPrimary, // Text on button
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.s16,
          horizontal: Spacing.s32,
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(Spacing.s24),
      fillColor: colorScheme.onSurface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Spacing.s16),
      ),
    ),
  );
}

// Shared Text Theme
TextTheme _getTextTheme(ColorScheme colorScheme) {
  return GoogleFonts.latoTextTheme(TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: colorScheme.onBackground,
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: colorScheme.onSurface,
    ),
    displayLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: colorScheme.primary,
    ),
    displayMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurface,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurface,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: colorScheme.primary,
    ),
  ));
}
