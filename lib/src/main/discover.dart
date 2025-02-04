import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:picole/solution/provider.dart';
import 'package:picole/src/onboard/welcome.dart';
import 'package:picole/solution/shared.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/ui/main/ui_discover.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => DiscoverPageState();
}

class DiscoverPageState extends State<DiscoverPage> {
  User? client;
  Post? featured;
  List<bool> config = [true, true];

  List<Post>? posts;
  bool isUpdated = false;

  @override
  Widget build(BuildContext context) {
    return uiDiscover(context, this);
  }

  @override
  void initState() {
    super.initState();
    _initialize(context);
  }

  void _initialize(BuildContext context) async {
    _validateVersion(context);
    if (context.mounted) await _validateCredentials(context);
    if (context.mounted) {
      _getClient(context);
      _getConfig(context);
      _getFeaturedPost(context);
      getFeeds(context);
    }
  }

  Future<void> _validateCredentials(context) async {
    User? client;
    try {
      client = await Client.restore();
      if (client == null) {
        setObsolete(false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    } catch (e) {
      setObsolete(false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }

  Future<void> _validateVersion(context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    int buildNumber = int.parse(packageInfo.buildNumber);

    final meta = await supabase.from('appmeta').select('meta, value');
    int minVersion = meta[0]['value'];

    if (buildNumber < minVersion) {
      saveCredentials('', '');
      setObsolete(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }

  void _getFeaturedPost(context) async {
    final res = await Client.getFeatured();
    final featuredProvider =
        Provider.of<GlobalProvider>(context, listen: false);

    if (featuredProvider.featured != null) {
      if (!mounted) return;
      setState(() {
        featured = featuredProvider.featured;
      });
    } else {
      Provider.of<GlobalProvider>(context, listen: false).setFeatured(res);

      if (!mounted) return;
      setState(() {
        featured = res;
      });
    }
  }

  void _getClient(context) async {
    final res = await Client.session();

    if (!mounted) return;
    setState(() {
      client = res;
    });

    if (res != null) {
      NotificationController.startListening(res.id);
    }

    final provider = Provider.of<GlobalProvider>(context, listen: false);

    if (provider.client != null) {
      if (!mounted) return;
      setState(() {
        client = provider.client;
      });
    } else {
      Provider.of<GlobalProvider>(context, listen: false).setClient(res);

      if (!mounted) return;
      setState(() {
        client = res;
      });
    }
  }

  void getFeeds(context) async {
    final res = await Post.bulk();

    if (!mounted) return;
    setState(() {
      posts = res;
    });
  }

  void _getConfig(BuildContext context) async {
    final provider = Provider.of<GlobalProvider>(context, listen: false);
    final config = await getConfig();

    if (!mounted) return;
    setState(() {
      provider.setConfigBulk(config);
    });
  }
}
