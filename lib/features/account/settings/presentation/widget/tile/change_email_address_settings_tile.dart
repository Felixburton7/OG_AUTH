import 'package:flutter/material.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/settings_tile.dart';
import 'package:go_router/go_router.dart';

class ChangeEmailAddressSettingsTile extends StatelessWidget {
  const ChangeEmailAddressSettingsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      leading: Icons.email,
      title: "Change email address",
      onTap: () => context.push(Routes.changeEmailAddress.path),
    );
  }
}
