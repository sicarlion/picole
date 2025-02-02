import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/ui/details/ui_preview.dart';

class ImagePreviewPage extends StatefulWidget {
  final Post post;
  final User client;
  final bool isFeatured;

  const ImagePreviewPage(
      {super.key,
      required this.post,
      required this.client,
      required this.isFeatured});

  @override
  State<ImagePreviewPage> createState() => ImagePreviewPageState();
}

class ImagePreviewPageState extends State<ImagePreviewPage> {
  final TextEditingController commentController = TextEditingController();

  List<Comment>? comments;
  bool isCommenting = false;
  bool isDownloading = false;
  bool isDownloaded = false;

  @override
  Widget build(BuildContext context) {
    return uiPreview(context, this, widget);
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addComment(String postId, String userId, String value) async {
    setState(() {
      commentController.text = '';
      isCommenting = true;
    });
    await Comment.add(postId, userId, value);
    getComments();
    setState(() {
      isCommenting = false;
    });
  }

  void getComments() async {
    final commentsData = await Comment.get(widget.post.id);
    if (comments != null && comments!.isNotEmpty) comments!.clear();
    setState(() {
      comments = commentsData.reversed.toList();
    });
  }

  void download(Post post) async {
    setState(() {
      isDownloading = true;
    });

    File file = await DefaultCacheManager().getSingleFile(post.image.url);
    Uint8List bytes = await file.readAsBytes();

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      int sdkInt = androidInfo.version.sdkInt;

      if (sdkInt <= 28) {
        // Android 9 and below: Use external storage directory
        if (await Permission.storage.request().isGranted) {
          String newPath =
              "/storage/emulated/0/Pictures"; // Change to "Download" if needed
          Directory newDir = Directory(newPath);
          if (!newDir.existsSync()) {
            newDir.createSync(recursive: true);
          }

          File newFile = File("$newPath/${post.image.url.split('/').last}");
          await newFile.writeAsBytes(bytes);
        }
      } else {
        // Android 10+ (API 29+): Use MediaStore
        if (await Permission.photos.request().isGranted) {
          await ImageGallerySaver.saveImage(bytes,
              name: post.image.url.split('/').last);
        }
      }
    }

    setState(() {
      isDownloading = false;
      isDownloaded = true;
    });
  }
}
