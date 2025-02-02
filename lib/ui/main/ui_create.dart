import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picole/solution/tools.dart';
import 'package:picole/src/main/create.dart';
import 'package:picole/src/main/discover.dart';
import 'package:picole/src/details/viewer.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/src/main/notifications.dart';
import 'package:picole/src/main/settings.dart';

Widget uiCreate(BuildContext context, CreatePageState state) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(state),
          Padding(
            padding: toScale(context, 11, 0, 11, 5),
            child: SingleChildScrollView(
              child: AnimatedOpacity(
                opacity: state.isProcessing ? 0.5 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: toScale(context, 0, 10, 0, 0),
                      child: _buildHeader(context, state),
                    ),
                    _buildImageForm(context, state),
                    _buildMetaForm(context, state),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomNavBar(context)
        ],
      ),
    ),
  );
}

Widget _buildBackground(CreatePageState state) {
  return Container(
    constraints: BoxConstraints.expand(),
    decoration: BoxDecoration(color: Colors.black),
    child: ClipRRect(
      child: Stack(
        children: [
          if (state.file != null)
            Container(
              constraints: BoxConstraints.expand(),
              child: FadeInImage(
                placeholder: AssetImage('assets/placeholder.png'),
                image: FileImage(state.file!),
                fit: BoxFit.cover,
              ),
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
    ),
  );
}

Widget _buildHeader(BuildContext context, CreatePageState state) {
  return Padding(
    padding: EdgeInsets.only(bottom: 32),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create",
              style: TextStyle(fontSize: 28.0, color: Colors.white),
            ),
            SizedBox(height: 6.0),
            Text(
              "Picole",
              style: TextStyle(fontSize: 16.0, color: Colors.white70),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildImageForm(BuildContext context, CreatePageState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Image",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Stack(
          children: [
            GestureDetector(
              onTap: state.isProcessing ? null : state.pickImage,
              child: Hero(
                tag: 'peek',
                child: Container(
                  alignment: Alignment.center,
                  width: 512,
                  height: 128,
                  decoration: BoxDecoration(
                    border:
                        state.hasError ? Border.all(color: Colors.red) : null,
                    color: const Color.fromRGBO(20, 20, 20, 1),
                    image: state.file != null
                        ? DecorationImage(
                            image: FileImage(state.file!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: state.file == null
                        ? const Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                        : state.isProcessing
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Container(
                                alignment: Alignment.bottomRight,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(0.6, -0.8),
                                    end: Alignment(1, 1),
                                    colors: [
                                      Colors.transparent,
                                      Colors.black54
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(8, 8, 12, 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageViewerPage(
                                            file: state.file!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Preview",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Icon(
                                          Icons.visibility,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildMetaForm(BuildContext context, CreatePageState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Title",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Container(
          constraints: BoxConstraints(maxWidth: 512),
          child: TextField(
            controller: state.title,
            onChanged: (s) {
              state.setError(0);
            },
            decoration: InputDecoration(
              hintText: "To be or not to be.",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: state.hasError ? Colors.red : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: state.hasError ? Colors.red : Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      Text(
        "Description",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Container(
          constraints: BoxConstraints(maxWidth: 512, maxHeight: 128),
          child: TextField(
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            maxLines: null,
            minLines: null,
            controller: state.description,
            onChanged: (s) {
              state.setError(0);
            },
            decoration: InputDecoration(
              hintText: "Describe this art backstory",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      Text(
        "Tags",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Container(
          constraints: BoxConstraints(maxWidth: 512, maxHeight: 128),
          child: TextField(
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            maxLines: null,
            minLines: null,
            controller: state.tags,
            onChanged: (s) {
              state.setError(0);
            },
            decoration: InputDecoration(
              hintText:
                  "smiling, scenery, sleeping, campfire, nature, forest, calm, incest-",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      SizedBox(height: 32),
      Text(
        "Is this post suggestive?",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General, it is safe for everyone.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  'Every post that are suitable to view at any ages fall under this category.',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
            leading: Radio<Rating>(
              value: Rating.general,
              activeColor: Colors.blue,
              groupValue: state.rating,
              onChanged: (Rating? value) {
                state.setRating(value);
              },
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sensitive, might contain suggestive material.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  'Underwear, bloods, fetism, arousing art is considered sensitive.',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
            leading: Radio<Rating>(
              value: Rating.sensitive,
              activeColor: Colors.orange,
              groupValue: state.rating,
              onChanged: (Rating? value) {
                state.setRating(value);
              },
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explicit, not safe to view at work.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  'Sexual, brutal, dead dove, gore content must be obviously stated.',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
            leading: Radio<Rating>(
              value: Rating.explicit,
              activeColor: Colors.red,
              groupValue: state.rating,
              onChanged: (Rating? value) {
                state.setRating(value);
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 32),
      Text(
        "Is this post showcasing art?",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No, it contains general topic.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  'You can post anything. But this will be unlisted towards search page or user defined settings.',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
            leading: Radio<Categories>(
              value: Categories.normal,
              activeColor: Colors.white,
              groupValue: state.categories,
              onChanged: (Categories? value) {
                state.setCategories(value);
              },
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yes, it only contains art.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  'Post must only and solely contain a form of drawing or animation, regardless its digital or traditional.',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
            leading: Radio<Categories>(
              value: Categories.art,
              activeColor: Colors.white,
              groupValue: state.categories,
              onChanged: (Categories? value) {
                state.setCategories(value);
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 32),
      TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
        ),
        onPressed: () async {
          if (await state.createPost() == 0) {
            if (context.mounted) {
              _navigate(context, DiscoverPage());
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text("Post!"),
        ),
      ),
      SizedBox(height: 12),
      Text(
        state.errorMessage,
        style:
            Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.red),
      ),
    ],
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
          child: Padding(
            padding: toScale(context, 8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _navigate(context, DiscoverPage()),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.explore_outlined, color: Colors.white),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: NotificationController.hasNew,
                  builder: (context, hasNew, _) {
                    return GestureDetector(
                      onTap: () {
                        _navigate(context, NotificationsPage());
                        NotificationController.hasNew.value = false;
                      },
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.notifications_outlined,
                          color: hasNew ? Colors.red : Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigate(context, CreatePage()),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.add_box, color: Colors.red, size: 34),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.account_circle_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: 80,
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigate(context, SettingsPage()),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
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
