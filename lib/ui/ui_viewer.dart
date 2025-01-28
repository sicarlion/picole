import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:picole/tools/database.dart';

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
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: postData?.id ?? 'peek',
                child: _buildPreviewer(context, postData, file),
              ),
            ),
          ],
        ),
        _buildCustomAppBar(context),
      ],
    ),
  );
}

Widget _buildPreviewer(BuildContext context, Post? postData, File? file) {
  return InteractiveViewer(
    clipBehavior: Clip.none, // Prevent clipping to allow free movement
    minScale: 0.5, // Minimum zoom scale
    maxScale: 4.0, // Maximum zoom scale
    child: Center(
      child: postData != null
          ? CachedNetworkImage(
              imageUrl: postData.image.url,
              progressIndicatorBuilder: (context, url, downloadProgress) {
                return CircularProgressIndicator(
                  value:
                      downloadProgress.progress, // Show the progress percentage
                  color: Colors.white,
                );
              },
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                color: Colors.red,
              ),
              fadeInDuration:
                  const Duration(milliseconds: 300), // Smooth fade-in effect
            )
          : file != null
              ? FadeInImage(
                  placeholder: AssetImage('assets/placeholder.png'),
                  image: FileImage(file))
              : null,
    ),
  );
}
