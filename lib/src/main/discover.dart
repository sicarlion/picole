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
  bool isCached = true;

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
    await _validateCredentials(context);
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
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
    final provider = Provider.of<GlobalProvider>(context, listen: false);

    if (provider.featured != null) {
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
    setState(() {
      if (posts != null && posts!.isNotEmpty) posts = null;
    });
    final res = await Post.bulk();

    setState(() {
      posts = res;
    });
  }

  void _getConfig(BuildContext context) async {
    final resIsCached = await getNetworkCache();
    setState(() {
      isCached = resIsCached;
    });
  }
}
