import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picole/src/create.dart';
import 'package:picole/src/discover.dart';
import 'package:picole/tools/database.dart';

Widget uiCreate(BuildContext context, state) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(state),
          Padding(
            padding: EdgeInsets.fromLTRB(48, 96, 48, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, state),
                  _buildImageForm(context, state),
                  _buildMetaForm(context, state),
                ],
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
            FadeInImage(
              placeholder: AssetImage("assets/placeholder.png"),
              image: FileImage(state.file!),
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
        child: GestureDetector(
          onTap: state.isProcessing ? null : state.pickImage,
          child: Container(
            alignment: Alignment.center,
            width: 512,
            height: 128,
            decoration: BoxDecoration(
              border: state.hasError ? Border.all(color: Colors.red) : null,
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
                      : null,
            ),
          ),
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
                  'General, it is safe for everyone',
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
                  'Sensitve, might contain suggestive material',
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
                  'Explicit, not safe to view at work',
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
          final result = await state.createPost();

          if (result == 0) {
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 100),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DiscoverPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const curve = Curves.easeInOut;

                    return FadeTransition(
                      opacity: animation.drive(CurveTween(curve: curve)),
                      child: child,
                    );
                  },
                ),
              );
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
      SizedBox(height: 52 * 2),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _navigate(context, DiscoverPage()),
                child: Icon(Icons.explore_outlined, color: Colors.white),
              ),
              SizedBox(width: 60),
              Icon(Icons.add_box, color: Colors.red, size: 34),
            ],
          ),
        ),
      ),
    ),
  );
}

void _navigate(BuildContext context, page) {
  Navigator.of(context).pop();
}
