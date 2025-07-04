import 'package:flutter/material.dart';

class TextFieldEditProfile extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool enabled; // New parameter to control if the TextField is enabled

  const TextFieldEditProfile({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType, // Optional parameter for keyboard type
    this.enabled = true, // Default to true if not specified
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      keyboardType: keyboardType,
      enabled:
          enabled, // Use the enabled parameter to control the editing state
    );
  }
}
