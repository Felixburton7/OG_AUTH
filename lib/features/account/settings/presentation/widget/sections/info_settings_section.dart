import 'package:flutter/material.dart';
import 'package:panna_app/features/account/settings/presentation/widget/tile/settings_tile.dart';
import 'package:panna_app/features/account/settings/presentation/widget/section_template/settings_section.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoSettingsSection extends StatefulWidget {
  const InfoSettingsSection({
    super.key,
  });

  @override
  State<InfoSettingsSection> createState() => _InfoSettingsSectionState();
}

class _InfoSettingsSectionState extends State<InfoSettingsSection> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Info',
      items: [
        SettingsTile(
          leading: Icons.info_outline,
          title: "Version: ${_packageInfo.version} updates incoming!",
          onTap: null,
        ),
      ],
    );
  }
}
