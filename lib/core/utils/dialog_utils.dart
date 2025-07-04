import 'package:flutter/material.dart';
import 'package:panna_app/core/dialog/confirmation_dialog.dart';

/// Utility class for showing common dialogs throughout the app.
class DialogUtils {
  const DialogUtils._();

  /// Shows a confirmation dialog and returns true if confirmed, false otherwise.
  ///
  /// - [title]: The title of the dialog
  /// - [message]: The content/message to display
  /// - [confirmText]: Text for confirm button (default: "Confirm")
  /// - [cancelText]: Text for cancel button (default: "Cancel")
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        title: title,
        content: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: () {
          Navigator.of(dialogContext).pop(true);
        },
        onCancel: () {
          Navigator.of(dialogContext).pop(false);
        },
      ),
    );

    // Return false if the dialog was dismissed without selecting an option
    return result ?? false;
  }
}
