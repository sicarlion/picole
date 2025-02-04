import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/solution/provider.dart';
import 'package:picole/solution/shared.dart' as shared;
import 'package:picole/solution/tools.dart';
import 'package:picole/src/main/create.dart';
import 'package:picole/src/main/discover.dart';
import 'package:picole/src/main/notifications.dart';
import 'package:picole/src/main/settings.dart';
import 'package:provider/provider.dart';

Widget uiSettings(BuildContext context, SettingsPageState state) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: toScale(context, 11, 0, 11, 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: toScale(context, 0, 10, 0, 0),
                    child: _buildHeader(context, state),
                  ),
                  _buildSettings(context, state),
                ],
              ),
            ),
          ),
          _buildBottomNavBar(context)
        ],
      ),
    ),
  );
}

Widget _buildSettings(BuildContext context, SettingsPageState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Consumer<GlobalProvider>(
        builder: (context, value, child) => _buildToggle(
          context,
          title: "Fetch image with cache (experimental)",
          description:
              "Cache all downloaded image for faster loading and reduce data usage, in cost of laggy perfomance.",
          value: value.config[0],
          onChanged: (bool newValue) {
            value.setConfig(0, newValue);
            shared.setConfig(value.config);
          },
        ),
      ),
      SizedBox(height: 16),
      Consumer<GlobalProvider>(
        builder: (context, value, child) => _buildToggle(
          context,
          title: "Hide general posts from Discover",
          description: "Maybe, just maybe, you need to keep everything clean~?",
          value: value.config[1],
          onChanged: (bool newValue) {
            value.setConfig(1, newValue);
            shared.setConfig(value.config);
          },
        ),
      ),
    ],
  );
}

Widget _buildToggle(
  BuildContext context, {
  required String title,
  required String description,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Transform.scale(
        scale: 0.8,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
        ),
      ),
      SizedBox(width: 8.0),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: true,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.labelMedium,
              softWrap: true,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildHeader(BuildContext context, SettingsPageState state) {
  return Padding(
    padding: EdgeInsets.only(bottom: 32),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings",
              style: TextStyle(fontSize: 28.0, color: Colors.white),
            ),
            SizedBox(height: 6.0),
            Text(
              "Picole",
              style: TextStyle(fontSize: 16.0, color: Colors.white70),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildBottomNavBar(BuildContext context) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: EdgeInsets.all(0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [BoxShadow(blurRadius: 8)],
            border: Border(top: BorderSide(width: 1, color: Colors.white24)),
          ),
          child: Padding(
            padding: toScale(context, 8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _navigate(context, DiscoverPage()),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.explore_outlined, color: Colors.white),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: NotificationController.hasNew,
                  builder: (context, hasNew, _) {
                    return GestureDetector(
                      onTap: () {
                        _navigate(context, NotificationsPage());
                        NotificationController.hasNew.value = false;
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.notifications_outlined,
                          color: hasNew ? Colors.red : Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigate(context, CreatePage()),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.add, color: Colors.red, size: 34),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigate(context, SettingsPage()),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void _navigate(BuildContext context, page) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;

        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: curve)),
          child: child,
        );
      },
    ),
  );
}
