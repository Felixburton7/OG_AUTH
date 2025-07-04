import 'package:flutter/material.dart';

// This extension adds useful utility getters and methods to the BuildContext class,
// making it easier to access common Flutter functionalities related to the current context.
extension BuildContextExtensions on BuildContext {
  // Provides access to the current theme of the app.
  ThemeData get theme => Theme.of(this);

  // Provides access to the current text theme, which defines the styles for text elements.
  TextTheme get textTheme => theme.textTheme;

  // Provides access to the current color scheme, which contains the colors used throughout the app.
  ColorScheme get colorScheme => theme.colorScheme;

  // Provides access to the default text style for the current context.
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  // Provides access to the media query data (e.g., screen size, orientation) for the current context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  // Provides access to the current focus scope, used to manage focus for text fields and other input widgets.
  FocusScopeNode get focusScope => FocusScope.of(this);

  // Provides access to the Scaffold widget, which provides the structure for the visual interface of the app.
  ScaffoldState get scaffold => Scaffold.of(this);

  // Provides access to the ScaffoldMessenger, which is used to show SnackBars and other transient messages.
  ScaffoldMessengerState get scaffoldMessenger =>
      ScaffoldMessenger.of(this)..hideCurrentSnackBar();

  void closeKeyboard() => focusScope.unfocus();

  /// Shows an error snackbar with specified message.
  void showErrorSnackBarMessage(String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: colorScheme.error, // Red background for errors
        content: Text(
          message,
          style: TextStyle(color: colorScheme.onError), // White text
        ),
        behavior: SnackBarBehavior.fixed, // Floating snackbar
        duration: const Duration(seconds: 3), // Auto-dismiss after 3 seconds
        action: SnackBarAction(
          label: 'Close',
          textColor: colorScheme.onError,
          onPressed: () {
            // Optional: Additional actions on close
          },
        ),
      ),
    );
  }

  /// Shows a success snackbar with specified message.
  void showSnackBarMessage(String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: colorScheme.primary, // Primary color for success
        content: Text(
          message,
          style:
              TextStyle(color: colorScheme.onPrimary), // Appropriate text color
        ),
        behavior: SnackBarBehavior.floating, // Floating snackbar
        duration: const Duration(seconds: 3), // Auto-dismiss after 3 seconds
        action: SnackBarAction(
          label: 'Close',
          textColor: colorScheme.onPrimary,
          onPressed: () {
            // Optional: Additional actions on close
          },
        ),
      ),
    );
  }
}
//   // Utility method to close the keyboard by unfocusing the current input field.
//   void closeKeyboard() => focusScope.unfocus();

//   // Method to show a SnackBar with an error message, using the color scheme's error color.
//   void showErrorSnackBarMessage(
//     String message,
//   ) {
//     scaffoldMessenger.showSnackBar(
//       SnackBar(
//         backgroundColor: colorScheme.error,
//         content: Text(
//           message,
//           style: TextStyle(color: colorScheme.onError),
//         ),
//       ),
//     );
//   }

//   // Method to show a SnackBar with a standard message.
//   void showSnackBarMessage(
//     String message,
//   ) =>
//       scaffoldMessenger.showSnackBar(
//         SnackBar(
//           content: Text(
//             message,
//           ),
//         ),
//       );
// }

// //Extensions add optional methods and properties to a class (like `BuildContext`) that can be used by calling them on an instance of the class (e.g., `context.theme`) when the extension is in scope.
// How to Use These Extensions:
// Use the extensions by calling the methods or properties on an instance of the class, such as `context`, which is an instance of `BuildContext`. For example:

// ```dart
// void someFunction(BuildContext context) {
//   final theme = context.theme; // Accesses the theme using the extension
//   context.showSnackBarMessage("Hello!"); // Shows a SnackBar using the extension
// }
// ```

// Here, `context` is the keyword representing an instance of `BuildContext`, and the extension methods like `theme` or `showSnackBarMessage` are accessible through it.