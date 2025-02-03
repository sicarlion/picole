import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/solution/provider.dart';
import 'package:picole/solution/tools.dart';
import 'package:picole/src/details/preview.dart';
import 'package:picole/src/main/create.dart';
import 'package:picole/src/main/discover.dart';
import 'package:picole/src/main/notifications.dart';
import 'package:picole/src/main/settings.dart';
import 'package:provider/provider.dart';

Widget uiNotifications(BuildContext context, NotificationsPageState state) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: toScale(context, 11, 0, 11, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: toScale(context, 0, 10, 0, 0),
                  child: _buildHeader(context, state),
                ),
                _buildNotifications(context, state),
              ],
            ),
          ),
          _buildBottomNavBar(context)
        ],
      ),
    ),
  );
}

Widget _buildNotifications(BuildContext context, NotificationsPageState state) {
  return Expanded(
    // Make it take only the available space
    child: ValueListenableBuilder<List<Notifications>>(
      valueListenable: NotificationController.notifications,
      builder: (context, notifications, _) {
        if (notifications.isEmpty) {
          return Text(
            "Its either you don't have notifications, or the app twerking.",
            style: TextStyle(color: Colors.white),
          );
        }
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return FutureBuilder(
              future: notification.type == NotificationType.post
                  ? Post.find(notification.postId!)
                  : Future.value(null),
              builder: (context, snapshot) {
                return Opacity(
                  opacity:
                      notifications[index].status == NotificationStatus.sent
                          ? 1.0
                          : 0.5,
                  child: GestureDetector(
                    onTap: () {
                      if (notification.type == NotificationType.post) {
                        final client =
                            Provider.of<GlobalProvider>(context, listen: false)
                                .client;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ImagePreviewPage(
                                post: snapshot.data!,
                                client: client!,
                                isFeatured: false),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      title: Text(
                        notification.message,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        timeAgo(notification.timestamp!),
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: notification.type == NotificationType.post
                          ? snapshot.connectionState == ConnectionState.done &&
                                  snapshot.hasData
                              ? SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.image.url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 52,
                                  height: 52,
                                  child: Center(
                                    child: Transform.scale(
                                      scale: 0.7,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                          : null,
                      contentPadding: EdgeInsets.only(bottom: 16),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ),
  );
}

Widget _buildHeader(BuildContext context, NotificationsPageState state) {
  return Padding(
    padding: EdgeInsets.only(bottom: 32),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notifications",
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
                          Icons.notifications,
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
                      Icons.settings_outlined,
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
