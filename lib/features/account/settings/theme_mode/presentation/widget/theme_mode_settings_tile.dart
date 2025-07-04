import 'package:flutter/material.dart';
import 'package:panna_app/core/extensions/string_extensions.dart';
import 'package:panna_app/core/extensions/theme_extension.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/widget/tile/settings_tile.dart';

class ThemeModeSettingsTile extends StatelessWidget {
  const ThemeModeSettingsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = context.watchCurrentThemeMode;

    return SettingsTile(
      leading: Icons.dark_mode,
      title: "Theme mode",
      subtitle: theme.name.capitalize(),
      onTap: () => context.push(Routes.themeMode.path),
    );
  }
}
