import 'dart:io';

import 'package:flutter/material.dart';
import 'package:picole/tools/database.dart';
import 'package:picole/ui/ui_viewer.dart';

class ImageViewerPage extends StatelessWidget {
  final Post? postData;
  final File? file;

  const ImageViewerPage({super.key, this.postData, this.file});

  @override
  Widget build(BuildContext context) {
    return uiViewer(context, this, postData, file);
  }
}
