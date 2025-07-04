// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:panna_app/core/extensions/build_context_extensions.dart';
// import 'package:go_router/go_router.dart';

// class ConfirmationDialog extends StatelessWidget {
//   const ConfirmationDialog({
//     required this.title,
//     required this.message,
//     required this.confirmText,
//     super.key,
//   });

//   final String title;
//   final String message;
//   final String confirmText;

//   @override
//   Widget build(BuildContext context) {
//     return !kIsWeb && Platform.isIOS
//         ? _IosConfirmationDialog(
//             title: title,
//             message: message,
//             confirmText: confirmText,
//           )
//         : _AndroidConfirmationDialog(
//             title: title,
//             message: message,
//             confirmText: confirmText,
//           );
//   }
// }

// class _AndroidConfirmationDialog extends StatelessWidget {
//   const _AndroidConfirmationDialog({
//     required this.title,
//     required this.message,
//     required this.confirmText,
//   });

//   final String title;
//   final String message;
//   final String confirmText;

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(title),
//       content: Text(message),
//       actions: [
//         TextButton(
//           style: TextButton.styleFrom(
//             foregroundColor: context.colorScheme.onSurface,
//           ),
//           onPressed: () => context.pop(),
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           style: TextButton.styleFrom(
//             foregroundColor: context.colorScheme.onSurface,
//           ),
//           onPressed: () => context.pop(true),
//           child: Text(confirmText),
//         ),
//       ],
//     );
//   }
// }

// class _IosConfirmationDialog extends StatelessWidget {
//   const _IosConfirmationDialog({
//     required this.title,
//     required this.message,
//     required this.confirmText,
//   });

//   final String title;
//   final String message;
//   final String confirmText;

//   @override
//   Widget build(BuildContext context) {
//     const OutlinedBorder buttonShape = RoundedRectangleBorder(
//       borderRadius: BorderRadius.zero,
//     );

//     return CupertinoAlertDialog(
//       title: Text(title),
//       content: Text(message),
//       actions: [
//         TextButton(
//           style: TextButton.styleFrom(
//             foregroundColor: context.colorScheme.onSurface,
//             shape: buttonShape,
//           ),
//           onPressed: () => context.pop(),
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           style: TextButton.styleFrom(
//             foregroundColor: context.colorScheme.onSurface,
//             shape: buttonShape,
//           ),
//           onPressed: () => context.pop(true),
//           child: Text(confirmText),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:panna_app/core/constants/colors.dart';

/// A reusable confirmation dialog for actions that require user confirmation.
///
/// This dialog presents a title, content message, and two buttons (confirm and cancel).
/// The appearance and text of the buttons can be customized.
class ConfirmationDialog extends StatelessWidget {
  /// The title displayed at the top of the dialog.
  final String title;

  /// The content text displayed in the dialog body.
  final String content;

  /// The text for the confirmation button (e.g., "Yes", "Confirm", "Accept").
  final String confirmText;

  /// The text for the cancel button (e.g., "No", "Cancel").
  final String cancelText;

  /// Callback function executed when the confirm button is pressed.
  final VoidCallback onConfirm;

  /// Optional callback function executed when the cancel button is pressed.
  /// If not provided, the dialog will simply close.
  final VoidCallback? onCancel;

  /// Color for the confirm button. Defaults to the primary green color.
  final Color confirmColor;

  /// Color for the cancel button. Defaults to a light grey color.
  final Color cancelColor;

  /// Text color for the confirm button. Defaults to white.
  final Color confirmTextColor;

  /// Text color for the cancel button. Defaults to dark grey.
  final Color cancelTextColor;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.onCancel,
    this.confirmColor = AppColors.primaryGreen,
    this.cancelColor = Colors.grey,
    this.confirmTextColor = Colors.white,
    this.cancelTextColor = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            } else {
              Navigator.of(context).pop();
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: cancelColor.withOpacity(0.1),
            foregroundColor: cancelTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: Text(
            cancelText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cancelTextColor,
            ),
          ),
        ),

        // Confirm Button
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: confirmTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: Text(
            confirmText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: confirmTextColor,
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    );
  }
}
