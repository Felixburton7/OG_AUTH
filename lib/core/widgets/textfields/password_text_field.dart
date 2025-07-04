import 'package:flutter/material.dart';
import 'package:panna_app/core/widgets/textfields/base_text_field.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.onChanged,
    required this.errorText,
    required this.textInputAction,
    this.obscureText = true, // Default to true
  });

  final Function(String) onChanged;
  final TextInputAction textInputAction;
  final String? errorText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      labelText: "Password",
      onChanged: onChanged,
      textInputAction: textInputAction,
      obscureText: obscureText, // Use the passed obscureText value
      errorText: errorText,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
