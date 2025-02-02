import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/solution/tools.dart';
import 'package:picole/src/details/preview.dart';
import 'package:picole/src/details/viewer.dart';

Widget uiPreview(
    BuildContext context, dynamic state, dynamic post, bool isFeatured) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        _buildBackground(context, post),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomAppBar(context),
              _buildPreviewer(context, post),
              _buildMeta(context, post, state),
            ],
          ),
        ),
      ],
    ),
  );
}

_buildPreviewer(BuildContext context, Post post) {
  return Align(
    alignment: Alignment.center,
    child: LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double height = MediaQuery.sizeOf(context).height;
        double maxHeight = height / 1.5;

        double imageWidth = post.image.dimension[0].toDouble();
        double imageHeight = post.image.dimension[1].toDouble();

        // Scale down while maintaining aspect ratio
        double scale = (screenWidth / imageWidth).clamp(0.0, 1.0);
        double finalWidth = imageWidth * scale;
        double finalHeight = imageHeight * scale;

        // Ensure it fits within maxHeight
        if (finalHeight > maxHeight) {
          double heightScale = maxHeight / finalHeight;
          finalWidth *= heightScale;
          finalHeight = maxHeight;
        }

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewerPage(post: post),
            ),
          ),
          child: SizedBox(
            width: finalWidth,
            height: finalHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: post.thumb.url,
                  width: finalWidth,
                  height: finalHeight,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 300),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, 0.5),
                      end: Alignment(0.0, 1.0),
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

_buildMeta(BuildContext context, Post post, ImagePreviewPageState state) {
  return Padding(
    padding: toScale(context, 6, 3, 6, 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                post.title,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.clip,
              ),
            ),
            SizedBox(width: 8.0),
            GestureDetector(
              onTap: () async {
                state.download(post);
              },
              child: state.isDownloading
                  ? Transform.scale(
                      scale: 0.8,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      state.isDownloaded ? Icons.download_done : Icons.download,
                      color: Colors.white,
                    ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        if (post.description.trim() != "")
          Text(
            post.description,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white70),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        SizedBox(height: 32.0),
        Text(
          "Posted By",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: post.artist.avatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.artist.display,
                    style: Theme.of(context).textTheme.bodyLarge!),
                Text("0 minutes ago",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.grey)),
              ],
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white),
              child: Row(
                children: [
                  SizedBox(width: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Commision",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  SizedBox(width: 12.0),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 32.0),
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (post.tags != "")
                Text(
                  "Tags",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 8.0),
              Text(
                post.tags,
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              SizedBox(height: 16.0),
              Text(
                "Metadata",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                "${post.rating.name} - ${post.categories.name}\n${post.image.dimension}",
                style: Theme.of(context).textTheme.bodyMedium!,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildCustomAppBar(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(8),
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
          ],
        ),
      ),
    ),
  );
}

Widget _buildBackground(BuildContext context, Post postData) {
  List<double> viewport = [
    MediaQuery.of(context).size.width,
    MediaQuery.of(context).size.height
  ];

  return Container(
    constraints: const BoxConstraints.expand(),
    decoration: const BoxDecoration(color: Colors.grey),
    child: Stack(
      children: [
        CachedNetworkImage(
          imageUrl: postData.thumb.url,
          width: viewport[0],
          height: viewport[1],
          fit: BoxFit.cover,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}
