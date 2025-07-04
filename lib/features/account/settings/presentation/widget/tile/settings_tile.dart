import 'package:flutter/material.dart';
import 'package:panna_app/core/extensions/build_context_extensions.dart';
import 'package:panna_app/core/extensions/string_extensions.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.leading,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.name,
  });

  final IconData leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final String? name;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading),
      title: Text(
        title ?? '',
        style: context.textTheme.titleMedium,
      ),
      subtitle: !subtitle.isNullOrEmpty
          ? Text(
              subtitle!,
              style: context.textTheme.bodySmall,
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
