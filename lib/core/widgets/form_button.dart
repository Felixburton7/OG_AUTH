import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;

  const FormButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.decoration,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: decoration ??
            BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
