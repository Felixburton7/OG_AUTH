import 'package:flutter/material.dart';

class UnderlinedTextStack extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color underlineColor;
  final double underlineThickness;
  final double spacing;

  const UnderlinedTextStack({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.black,
    this.underlineColor = Colors.black,
    this.underlineThickness = 1.0,
    this.spacing = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            decoration: TextDecoration.none,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -spacing,
          child: Container(
            height: underlineThickness,
            color: underlineColor,
          ),
        ),
      ],
    );
  }
}

// Usage Example
class ExampleUsageStack extends StatelessWidget {
  const ExampleUsageStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: UnderlinedTextStack(
        text: 'Not now',
        fontSize: 15,
        fontWeight: FontWeight.w500,
        textColor: Colors.black,
        underlineColor: Colors.blue,
        underlineThickness: 2.0,
        spacing: 6.0,
      ),
    );
  }
}
