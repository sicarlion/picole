import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:picole/solution/database.dart';

Widget uiViewer(
    BuildContext context, dynamic state, Post? postData, File? file) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPreviewer(context, postData, file),
          ],
        ),
        _buildCustomAppBar(context),
      ],
    ),
  );
}

Widget _buildPreviewer(BuildContext context, Post? postData, File? file) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Hero(
    tag: postData?.id ?? 'peek',
    child: SizedBox(
      width: width,
      height: height,
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: postData != null
            ? CachedNetworkImage(
                imageUrl: postData.image.url,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Center(
                    // Centers the progress indicator
                    child: SizedBox(
                      width: 40, // Set width
                      height: 40, // Set height
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                fadeInDuration: const Duration(milliseconds: 300),
              )
            : file != null
                ? FadeInImage(
                    placeholder: AssetImage('assets/placeholder.png'),
                    image: FileImage(file))
                : Container(),
      ),
    ),
  );
}

Widget _buildCustomAppBar(BuildContext context) {
  return Positioned(
    top: 0,
    left: 5,
    right: 0,
    child: SafeArea(
      child: Container(
        height: 56,
        color: Colors.transparent,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
          ],
        ),
      ),
    ),
  );
}
