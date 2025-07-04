import 'package:flutter/material.dart';
import 'package:panna_app/features/account/settings/presentation/widget/section_template/settings_section.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/change_email_address_settings_tile.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/update_password_tile.dart';

import '../../../../../auth/presentation/widget/logout_settings_tile.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SettingsSection(
      title: 'Account',
      items: [
        ChangeEmailAddressSettingsTile(),
        UpdatePasswordSettingsTile(),
        LogoutSettingsTile(),
      ],
    );
  }
}
