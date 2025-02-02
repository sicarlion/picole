import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picole/solution/tools.dart';
import 'package:picole/src/details/preview.dart';
import 'package:picole/src/main/create.dart';
import 'package:picole/src/main/discover.dart';
import 'package:picole/src/main/settings.dart';

Widget uiDiscover(BuildContext context, DiscoverPageState state) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(state, context),
          Padding(
            padding: toScale(context, 5, 0, 5, 2),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: toScale(context, 6, 10, 6, 4),
                        child: _buildHeader(context, state),
                      ),
                      SizedBox(height: 32.0),
                      _buildFeaturedPost(context, state),
                      SizedBox(height: 32.0),
                      _buildFeedsHead(context, state),
                      SizedBox(height: 32.0),
                    ],
                  ),
                ),
                _buildFeeds(context, state),
              ],
            ),
          ),
          _buildBottomNavBar(context)
        ],
      ),
    ),
  );
}

_buildFeedsHead(BuildContext context, DiscoverPageState state) {
  return Column(
    children: [
      Container(
        alignment: Alignment.center,
        child: Text("Feeds",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      SizedBox(height: 16.0),
      Container(
        width: 128,
        height: 1,
        color: Colors.redAccent,
      ),
    ],
  );
}

Widget _buildBackground(DiscoverPageState state, BuildContext context) {
  return Container(
    constraints: BoxConstraints.expand(),
    decoration: BoxDecoration(color: Colors.black),
    child: ClipRRect(
      child: Stack(
        children: [
          // Wrap the CachedNetworkImage with AnimatedOpacity
          AnimatedOpacity(
            opacity: state.featured != null ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200), // Fade in duration
            child: state.featured != null
                ? Container(
                    constraints: BoxConstraints.expand(),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/placeholder.png'),
                      image: NetworkImage(state.featured!.thumb.url),
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 200),
                    ),
                  )
                : Container(),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}

_buildHeader(BuildContext context, DiscoverPageState state) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Discover",
            style: TextStyle(fontSize: 28.0, color: Colors.white),
          ),
          SizedBox(height: 6.0),
          Text(
            "Picole",
            style: TextStyle(fontSize: 16.0, color: Colors.white70),
          ),
        ],
      ),
      Spacer(),
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: ClipOval(
            child: state.client != null
                ? Image(
                    image: NetworkImage(state.client!.avatar),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
      ),
    ],
  );
}

_buildFeaturedPost(BuildContext context, DiscoverPageState state) {
  return AnimatedOpacity(
    opacity: state.featured != null ? 1.0 : 0.0,
    duration: Duration(milliseconds: 200), // Fade in duration
    child: Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 700,
        height: 240,
        child: Stack(
          children: [
            state.featured != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImagePreviewPage(
                            post: state.featured!,
                            client: state.client!,
                            isFeatured: true,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'featured',
                      child: Container(
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                FadeInImage(
                                  placeholder:
                                      AssetImage('assets/placeholder.png'),
                                  image:
                                      NetworkImage(state.featured!.thumb.url),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  fadeInDuration: Duration(milliseconds: 200),
                                ),
                                Container(
                                  constraints: BoxConstraints.expand(),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0, 1.0),
                                      end: Alignment(0, -1.0),
                                      colors: [
                                        Colors.black54,
                                        Colors.transparent
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.featured!.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${state.featured!.artist.display} · Daily Featured",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    ),
  );
}

Widget _buildFeeds(BuildContext context, DiscoverPageState state) {
  double width = MediaQuery.sizeOf(context).width;

  int row = 3;
  if (width > 1366) {
    row = 5;
  } else if (width > 1080) {
    row = 4;
  } else if (width > 720) {
    row = 3;
  } else if (width < 720) {
    row = 2;
  }

  if (state.posts == null) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  if (state.posts!.isEmpty) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No posts available"),
        ),
      ),
    );
  }

  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 0),
    sliver: SliverMasonryGrid.count(
      crossAxisCount: row,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childCount: state.posts!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePreviewPage(
                  post: state.posts![index],
                  client: state.client!,
                  isFeatured: false,
                ),
              ),
            );
          },
          child: SizedBox(
            width: state.posts![index].image.dimension[0],
            height: state.posts![index].image.dimension[1] /
                state.posts![index].image.dimension[0] *
                ((width - (getWidthScale(context, 5) * 2)) / row - 8),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Stack(
                children: [
                  state.isCached
                      ? Container(
                          constraints: BoxConstraints.expand(),
                          child: CachedNetworkImage(
                            imageUrl: state.posts![index].thumb.url,
                            fit: BoxFit.cover,
                            fadeOutDuration: Duration(milliseconds: 200),
                            fadeInDuration: Duration(milliseconds: 200),
                          ),
                        )
                      : Container(
                          constraints: BoxConstraints.expand(),
                          child: FadeInImage(
                            placeholder: AssetImage('assets/placeholder.png'),
                            image: NetworkImage(state.posts![index].thumb.url),
                            width: state.posts![index].image.dimension[0],
                            height: state.posts![index].image.dimension[1] /
                                state.posts![index].image.dimension[0] *
                                ((width - (getWidthScale(context, 5) * 2)) /
                                        row -
                                    8),
                            fit: BoxFit.cover,
                            fadeOutDuration: Duration(milliseconds: 200),
                            fadeInDuration: Duration(milliseconds: 200),
                          ),
                        ),
                  Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.0),
                        end: Alignment(-0.5, 1.0),
                        colors: [
                          Colors.transparent,
                          Color.fromRGBO(0, 0, 0, 0.4)
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 10,
                            foregroundImage: CachedNetworkImageProvider(
                              state.posts![index].artist.avatar,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            state.posts![index].artist.display,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildBottomNavBar(BuildContext context) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: EdgeInsets.all(0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [BoxShadow(blurRadius: 8)],
            border: Border(top: BorderSide(width: 1, color: Colors.white24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore, color: Colors.white),
              SizedBox(width: 60),
              GestureDetector(
                onTap: () => _navigate(context, CreatePage()),
                child: Icon(Icons.add, color: Colors.red, size: 34),
              ),
              SizedBox(width: 60),
              GestureDetector(
                onTap: () => _navigate(context, SettingsPage()),
                child: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _navigate(BuildContext context, page) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;

        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: curve)),
          child: child,
        );
      },
    ),
  );
}
