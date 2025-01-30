import 'package:flutter/material.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/ui/details/ui_preview.dart';

class ImagePreviewPage extends StatelessWidget {
  final Post post;
  final bool isFeatured;

  const ImagePreviewPage(
      {super.key, required this.post, required this.isFeatured});

  @override
  Widget build(BuildContext context) {
    return uiPreview(context, this, post, isFeatured);
  }
}
