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
