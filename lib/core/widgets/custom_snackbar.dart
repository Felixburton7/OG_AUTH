// custom_bottom_snackbar.dart

import 'package:flutter/material.dart';

class CustomBottomSnackbar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final bool isSuccess;
  final VoidCallback onDismiss;

  const CustomBottomSnackbar({
    Key? key,
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.isSuccess,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('CustomBottomSnackbar: Building snackbar with message: $message');

    return SafeArea(
      child: Material(
        elevation: 6.0,
        borderRadius: BorderRadius.circular(10.0),
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  print('CustomBottomSnackbar: Dismiss button pressed');
                  onDismiss();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
