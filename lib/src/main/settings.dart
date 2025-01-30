import 'package:flutter/material.dart';
import 'package:picole/solution/shared.dart';
import 'package:picole/ui/main/ui_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool isCached = true;

  @override
  void initState() {
    _getConfig(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return uiSettings(context, this);
  }

  void setConfig(BuildContext context, bool value) async {
    await setNetworkCache(value);
    setState(() {
      isCached = value;
    });
  }

  void _getConfig(BuildContext context) async {
    final resIsCached = await getNetworkCache();
    setState(() {
      isCached = resIsCached;
    });
  }
}
