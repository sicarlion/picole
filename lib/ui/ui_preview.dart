import 'dart:ui';
import 'package:flutter/material.dart';

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

Widget _buildBackground(postData) {
  return Container(
    constraints: const BoxConstraints.expand(),
    decoration: const BoxDecoration(color: Colors.grey),
    child: Stack(
      children: [
        FadeInImage(
          placeholder: const AssetImage("assets/placeholder.png"),
          image: NetworkImage(postData.thumb.url),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          fadeInDuration: const Duration(milliseconds: 200),
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

Widget uiPreview(
    BuildContext context, dynamic state, dynamic postData, bool isFeatured) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        _buildBackground(postData),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 48, 32, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.topLeft,
                  child: Hero(
                    tag: isFeatured ? 'featured' : postData.id,
                    child: _buildPreviewer(context, postData),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postData.title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        postData.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      const Text(
                        "Posted By",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              child: ClipOval(
                                child: FadeInImage(
                                  placeholder: const AssetImage(
                                      'assets/placeholder.png'),
                                  image: NetworkImage(postData.artist.avatar),
                                  fit: BoxFit.cover,
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  postData.artist.display,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  "12 followers",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildCustomAppBar(context),
      ],
    ),
  );
}

Widget _buildPreviewer(BuildContext context, dynamic postData) {
  final viewportWidth = MediaQuery.of(context).size.width;
  final viewportHeight = MediaQuery.of(context).size.height;

  final imageWidth = postData.thumb.dimension[0];
  final imageHeight = postData.thumb.dimension[1];

  double clamp;
  if (imageWidth > imageHeight) {
    clamp = viewportHeight * 1;
  } else {
    clamp = viewportHeight * 0.5;
  }

  return Container(
    constraints: BoxConstraints(maxWidth: clamp),
    child: Stack(
      children: [
        // FadeInImage to show the placeholder and the loaded image with fade effect
        FadeInImage(
          placeholder: const AssetImage('assets/placeholder.png'),
          image: NetworkImage(postData.thumb.url),
          width: postData.thumb.dimension[0],
          fit: BoxFit.contain,
          fadeInDuration: const Duration(milliseconds: 300),
        ),
        // Main image with loading progress and dynamic color filtering
        Image.network(
          postData.image.url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            double progress = loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : 0;
            return Container(
              foregroundDecoration: BoxDecoration(
                color: Colors.black.withValues(
                  alpha: (1.0 - progress) / 2,
                ), // Darkens at 0%, normal at 100%
              ),
              width: postData.thumb.dimension[0],
              height: postData.thumb.dimension[1] /
                      postData.thumb.dimension[0] *
                      viewportWidth -
                  36,
              constraints:
                  BoxConstraints(maxWidth: postData.thumb.dimension[0]),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  child,
                  // Apply a ColorFilter to make the image darker initially
                  CircularProgressIndicator(
                    color: Colors.white,
                    value: progress,
                  ),
                ],
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.white54,
              size: 100,
            ),
          ),
        ),
      ],
    ),
  );
}
