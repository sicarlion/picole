import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/solution/tools.dart';
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
              _buildMeta(context, post),
            ],
          ),
        ),
      ],
    ),
  );
}

_buildPreviewer(BuildContext context, Post post) {
  double height = MediaQuery.sizeOf(context).height;

  return Align(
    alignment: Alignment.center,
    child: Container(
      constraints: BoxConstraints(maxHeight: height / 1.5),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewerPage(
              post: post,
            ),
          ),
        ),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: post.thumb.url,
              width: post.image.dimension[0],
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    ),
  );
}

_buildMeta(BuildContext context, Post post) {
  return Padding(
    padding: toScale(context, 6, 3, 6, 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8.0),
        Text(
          post.description,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white70),
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
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.black],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
