import 'package:flutter/material.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/ui/main/ui_notifications.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    NotificationController.markAsRead();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return uiNotifications(context, this);
  }
}
