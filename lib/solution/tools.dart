import 'package:flutter/material.dart';

EdgeInsets toScale(BuildContext context, double left, double top, double right,
    double bottom) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  double scaledLeft = (left / 100) * width;
  double scaledTop = (top / 100) * height;
  double scaledRight = (right / 100) * width;
  double scaledBottom = (bottom / 100) * height;

  return EdgeInsets.fromLTRB(scaledLeft, scaledTop, scaledRight, scaledBottom);
}

double getWidthScale(BuildContext context, double widthScale) {
  double width = MediaQuery.of(context).size.width;

  double scaledWidth = (widthScale / 100) * width;

  return scaledWidth;
}

String timeAgo(String timestamp) {
  if (timestamp == '') {
    return 'Somewhen in the time.';
  }
  DateTime dateTime = DateTime.parse(timestamp).toUtc();
  DateTime now = DateTime.now().toUtc();

  Duration difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    return '${(difference.inDays / 7).floor()} weeks ago';
  }
}

List<String> toStringList(List<bool> boolList) {
  return boolList.map((bool value) => value.toString()).toList();
}

List<bool> toBoolList(List<String> stringList) {
  return stringList.map((String value) => value == 'true').toList();
}
