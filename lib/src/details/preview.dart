import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/ui/details/ui_preview.dart';

class ImagePreviewPage extends StatefulWidget {
  final Post post;
  final bool isFeatured;

  const ImagePreviewPage(
      {super.key, required this.post, required this.isFeatured});

  @override
  State<ImagePreviewPage> createState() => ImagePreviewPageState();
}

class ImagePreviewPageState extends State<ImagePreviewPage> {
  bool isDownloading = false;
  bool isDownloaded = false;

  @override
  Widget build(BuildContext context) {
    return uiPreview(context, this, widget.post, widget.isFeatured);
  }

  void download(Post post) async {
    setState(() {
      isDownloading = true;
    });

    File file = await DefaultCacheManager().getSingleFile(post.image.url);
    String path = file.path.split(Platform.pathSeparator).last;
    if (Platform.isAndroid) {
      await Permission.manageExternalStorage.request();
    }
    Directory? downloads = await getDownloadsDirectory();

    try {
      if (downloads == null) {
        return;
      }

      await file.rename("${downloads.path}/$path");
    } catch (e) {
      if (downloads == null) {
        return;
      }
      await file.copy("${downloads.path}/$path");
      await file.delete();
    }

    setState(() {
      isDownloading = false;
      isDownloaded = true;
    });
  }
}
