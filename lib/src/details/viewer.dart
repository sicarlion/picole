import 'dart:io';

import 'package:flutter/material.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/ui/details/ui_viewer.dart';

class ImageViewerPage extends StatelessWidget {
  final Post? post;
  final File? file;

  const ImageViewerPage({super.key, this.post, this.file});

  @override
  Widget build(BuildContext context) {
    return uiViewer(context, this, post, file);
  }
}
