import 'package:flutter/material.dart';
import 'package:picole/src/welcome.dart';
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
}
