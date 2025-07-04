import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:panna_app/core/constants/urls.dart';
import 'package:panna_app/core/router/routes.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/settings_tile.dart';
import 'package:panna_app/features/account/settings/presentation/widget/section_template/settings_section.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSettingsSection extends StatelessWidget {
  const HelpSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: "General",
      items: [
        SettingsTile(
          leading: Icons.gamepad,
          title: "LMS Game Rules",
          // subtitle: "Tap here to contact over email.",
          onTap: () => context.push(Routes.LmsRulesPage.path),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        SettingsTile(
          leading: Icons.handshake,
          title: "Safe Gambling Tools",
          onTap: () => launchUrl(Uri.parse(Urls.privacyPolicy)),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        SettingsTile(
          leading: Icons.description_outlined,
          title: "Terms and Conditions",
          onTap: () => launchUrl(Uri.parse(Urls.termsService)),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        SettingsTile(
          leading: Icons.privacy_tip_outlined,
          title: "Privacy Policy",
          onTap: () => launchUrl(Uri.parse(Urls.privacyPolicy)),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        SettingsTile(
          leading: Icons.contact_support_sharp,
          title: "Contact Us",
          onTap: () => launchUrl(Uri.parse(Urls.contactEmail)),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        SettingsTile(
          leading: Icons.settings,
          title: "Settings",
          onTap: () => context.push(Routes.settings.path),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}
