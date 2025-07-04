import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    super.key,
    required this.labelText,
    required this.onChanged,
    required this.textInputAction,
    required this.keyboardType,
    this.helperText,
    this.errorText,
    required this.obscureText, // Ensure it's required and passed
  });

  final Function(String) onChanged;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String labelText;
  final String? errorText;
  final String? helperText;
  final bool obscureText; // Set obscureText as a required parameter

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText, // Apply the obscureText value here
      decoration: InputDecoration(
        fillColor: Theme.of(context).canvasColor,
        labelText: labelText,
        helperText: helperText,
        errorText: errorText,
      ),
    );
  }
}
