import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:picole/src/create.dart';

import 'package:picole/src/discover.dart';
import 'package:picole/src/preview.dart';
import 'package:picole/tools/database.dart';

Widget uiDiscover(BuildContext context, DiscoverPageState state) {
  List<double> viewportRect = [
    MediaQuery.of(context).size.width,
    MediaQuery.of(context).size.height
  ];

  Future<void> onRefresh() async {
    state.revokePosts();
  }

  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(state),
          RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(context, state),
                  SizedBox(height: 32),
                  _buildFeaturedPost(viewportRect, state),
                  _buildFeeds(state, context),
                ],
              ),
            ),
          ),
          _buildBottomNavBar(context),
        ],
      ),
      floatingActionButton:
          kIsWeb || Theme.of(context).platform == TargetPlatform.linux
              ? FloatingActionButton(
                  onPressed: onRefresh,
                  tooltip: 'Refresh Page',
                  child: Icon(Icons.refresh),
                )
              : null,
    ),
  );
}

Widget _buildBackground(DiscoverPageState state) {
  return FutureBuilder(
    future: Client.getFeatured(),
    builder: (context, snapshot) {
      if (snapshot.hasError ||
          snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox();
      }

      return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Colors.grey),
        child: ClipRRect(
          child: Stack(
            children: [
              FadeInImage(
                placeholder: AssetImage("assets/placeholder.png"),
                image: NetworkImage(snapshot.data!.thumb.url),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                fadeInDuration: Duration(milliseconds: 200),
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
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Padding(
              //     padding: EdgeInsets.fromLTRB(32, 32, 32, 80),
              //     child: Image(
              //       image: AssetImage('assets/picole-title.png'),
              //       width: 148,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              //  ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildHeader(BuildContext context, DiscoverPageState state) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 96.0, left: 48.0),
        child: Column(
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
      ),
      Spacer(),
      Padding(
        padding: const EdgeInsets.only(top: 96.0, right: 48.0),
        child: FutureBuilder(
          future: Client.session(),
          builder: (context, snapshot) {
            if (snapshot.hasError ||
                snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox.shrink();
            }
            return Container(
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
                  child: FadeInImage(
                    placeholder: AssetImage('assets/placeholder.png'),
                    image: NetworkImage(snapshot.data!.avatar),
                    fit: BoxFit.cover,
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
              ),
            );
          },
        ),
      )
    ],
  );
}

Widget _buildFeaturedPost(List<double> viewportRect, DiscoverPageState state) {
  return FutureBuilder(
    future: Client.getFeatured(),
    builder: (context, snapshot) {
      if (snapshot.hasError ||
          snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox();
      }

      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: SizedBox(
            width: clampDouble(viewportRect[0], 0, 700),
            height: 240,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewPage(
                          postData: snapshot.data!,
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
                              offset: Offset(0, 4)),
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
                                    AssetImage("assets/placeholder.png"),
                                image: NetworkImage(snapshot.data!.thumb.url),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${snapshot.data!.artist.display} · Daily Featured",
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
                ),
              ],
            ),
          ),
        ),
      );
    },
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
            ],
          ),
        ),
      ),
    ),
  );
}

void _navigate(BuildContext context, page) {
  Navigator.of(context).push(
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

Widget _buildFeeds(DiscoverPageState state, context) {
  double width = MediaQuery.sizeOf(context).width;

  int row = 3;

  if (width > 1366) {
    row = 5;
  } else if (width > 1280) {
    row = 4;
  } else if (width < 720) {
    row = 2;
  }
  return Padding(
    padding: EdgeInsets.all(20),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text("Feeds",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Container(
                alignment: Alignment.center,
                child: Text("• • • • • •",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.redAccent,
                          fontSize: 21,
                        )),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        state.posts == null
            ? CircularProgressIndicator(color: Colors.white)
            : MasonryGridView.builder(
                itemCount: state.posts!.length,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: row,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(6),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.black54,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImagePreviewPage(
                                  postData: state.posts![index],
                                  isFeatured: false,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: state.posts![index].id,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FadeInImage(
                                        placeholder: const AssetImage(
                                            'assets/placeholder.png'),
                                        image: NetworkImage(
                                            state.posts![index].thumb.url),
                                        width: state
                                            .posts![index].image.dimension[0],
                                        fit: BoxFit.contain,
                                        fadeInDuration:
                                            const Duration(milliseconds: 300),
                                      ),
                                    ],
                                  ),
                                ),
                                if (state.posts![index].rating ==
                                    Rating.explicit)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 10,
                                          sigmaY: 10,
                                        ),
                                        child: Container(
                                          color: Colors.black54,
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Icon(
                                                Icons.eighteen_up_rating,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                "Explicit",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 10,
                                                      backgroundImage:
                                                          NetworkImage(state
                                                              .posts![index]
                                                              .artist
                                                              .avatar),
                                                    ),
                                                    SizedBox(width: 8.0),
                                                    Text(
                                                      state.posts![index].artist
                                                          .display,
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
                                if (state.posts![index].rating ==
                                    Rating.sensitive)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 10,
                                          sigmaY: 10,
                                        ),
                                        child: Container(
                                          color: Colors.black54,
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              Icon(
                                                Icons.visibility_off,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                "Sensitive",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 10,
                                                      backgroundImage:
                                                          NetworkImage(state
                                                              .posts![index]
                                                              .artist
                                                              .avatar),
                                                    ),
                                                    SizedBox(width: 8.0),
                                                    Text(
                                                      state.posts![index].artist
                                                          .display,
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
                                if (state.posts![index].rating ==
                                    Rating.general)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      child: Container(
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              CircleAvatar(
                                                radius: 10,
                                                backgroundImage: NetworkImage(
                                                    state.posts![index].artist
                                                        .avatar),
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                state.posts![index].artist
                                                    .display,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
      ],
    ),
  );
}
