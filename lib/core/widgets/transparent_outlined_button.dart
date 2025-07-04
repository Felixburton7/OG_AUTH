import 'package:flutter/material.dart';

class TransparentOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  const TransparentOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 50.0,
    this.borderRadius = 8.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(borderRadius), // Configurable border radius
        color: Colors.transparent, // Transparent background
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side:
              const BorderSide(color: Colors.transparent), // Transparent border
          minimumSize: Size.fromHeight(height), // Configurable height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                borderRadius), // Configurable border radius
          ),
        ),
        child: Text(text, style: textStyle
            // Theme.of(context).textTheme.button, // Configurable text style
            ),
      ),
    );
  }
}
