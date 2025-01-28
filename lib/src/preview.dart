import 'package:flutter/material.dart';
import 'package:picole/tools/database.dart';
import 'package:picole/ui/ui_preview.dart';

class ImagePreviewPage extends StatelessWidget {
  final Post postData;
  final bool isFeatured;

  const ImagePreviewPage(
      {super.key, required this.postData, required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    return uiPreview(context, this, postData, isFeatured);
  }
}
