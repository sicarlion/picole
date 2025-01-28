import 'package:flutter/material.dart';
import 'package:picole/tools/database.dart';
import 'package:picole/ui/ui_viewer.dart';

class ImageViewerPage extends StatelessWidget {
  final Post postData;

  const ImageViewerPage({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    return uiViewer(context, this, postData);
  }
}
