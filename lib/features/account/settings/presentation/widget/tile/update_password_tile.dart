import 'package:flutter/material.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/settings_tile.dart';
import 'package:go_router/go_router.dart';

class UpdatePasswordSettingsTile extends StatelessWidget {
  const UpdatePasswordSettingsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      leading: Icons.lock,
      title: "Reset password",
      onTap: () => context.push(Routes.updatePassword.path),
    );
  }
}
