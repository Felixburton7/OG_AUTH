import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:panna_app/core/router/routes.dart";
import "package:panna_app/core/utils/dialog_utils.dart";
import "package:panna_app/features/auth/presentation/bloc/auth_bloc.dart";
import "package:go_router/go_router.dart";

import "../../../../core/constants/colors.dart";


// CALLBACK, who want to use this logic >> put in a different place 

// Login settings tile -> Who? -> Settings page > private >> > If you only use it one way, add underscore 

// >> _LogoutSettingsTile (Make it private and part of usage)

// Mixin, two text field, 1) login view mixin <<< always manage operational logic (CUBIT) << JUst add view in mixin, cubit, add mixin instead, so it keeps seperate view mixin opration seperate
// in other step, in other step >> 
// Create custom email email field, stateless, convertable, page defines the component, 
// Have button, don't want to use only in login view, cutoff, presentation
// presentation/widget class, every subwidget, 
// Very useful to do private usage, any keys, many login buttons, why you see the login button, 
// only use login view, create
// Login tile full dialog, only view name, have to mention in name_, <<< everything we use, 
// Much easier for the team, much better for me 


// This Tile is found in the settings section and used in Account, but is put here as it is directly related to Auth.


class _LogoutSettingsTile extends StatelessWidget {
  const LogoutSettingsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.exit_to_app,
        color: AppColors.red,
      ),
      title: const Text(
        "Logout",
        style: TextStyle(
          color: AppColors.red,
        ),
      ),
      onTap: () => _showLogOutConfirmationDialog(context),
    );
  }

  Future<void> _showLogOutConfirmationDialog(
    BuildContext context,
  ) async {
    final confirmed = await DialogUtils.showConfirmationDialog(
      context,
      title: "Logout",
      message: "Are you sure you want to logout?",
      confirmText: "Logout",
    );

    if (confirmed && context.mounted) {
      context.read<AuthBloc>().add(const AuthLogoutButtonPressed());
      context.go(Routes.initial.path);
    }
    // if (confirmed && context.mounted && !Navigator.of(context).canPop()) {
    //   context.read<AuthBloc>().add(const AuthLogoutButtonPressed());
    //   context.go(Routes.initial.path);
    // }
  }
}
