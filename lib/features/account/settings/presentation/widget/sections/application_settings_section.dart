import 'package:flutter/material.dart';
import 'package:panna_app/features/account/settings/presentation/widget/section_template/settings_section.dart';
import 'package:panna_app/features/account/settings/theme_mode/presentation/widget/theme_mode_settings_tile.dart';

class ApplicationSettingsSection extends StatelessWidget {
  const ApplicationSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsSection(
      title: "Application",
      items: [
        ThemeModeSettingsTile(),
      ],
    );
  }
}
