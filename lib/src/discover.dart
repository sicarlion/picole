import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:picole/src/welcome.dart';
import 'package:picole/tools/credentials.dart';
import 'package:picole/tools/database.dart';
import 'package:picole/ui/ui_discover.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return uiDiscover(context, this);
  }

  @override
  void initState() {
    super.initState();
    _validateVersion(context);
    _validateCredentials(context);
  }

  Future<void> _validateCredentials(context) async {
    final client = await Client.restore();
    if (client == null) {
      {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    }
  }

  void _validateVersion(context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    final meta = await supabase.from('appmeta').select('meta, value');
    final minVersion = meta[0]['value'];

    if ("$version+$buildNumber" != minVersion) {
      saveCredentials('', '');
      setObsolete(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }
}
