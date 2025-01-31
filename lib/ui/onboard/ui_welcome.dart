import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picole/src/onboard/login.dart';
import 'package:picole/src/onboard/signup.dart';
import 'package:picole/solution/shared.dart';

Widget uiWelcomePage(BuildContext context, state) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(48, 128, 48, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Left-aligned
                mainAxisAlignment:
                    MainAxisAlignment.center, // Vertically centered
                children: [
                  _buildHeader(context),
                  SizedBox(height: 32.0),
                  _buildLoginForm(context, state),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildHeader(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image(
        width: 100,
        height: 100,
        image: AssetImage("assets/launcher/foreground.png"),
      ),
      SizedBox(height: 8.0),
      Text(
        "Welcome to Picole",
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
      ),
      SizedBox(height: 8.0),
      Text(
        "Yet another centralized image booru for all artist and people!",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    ],
  );
}

Widget _buildLoginForm(context, state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          fixedSize: WidgetStatePropertyAll(Size(500, 35)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.email_outlined,
              color: Colors.black,
            ),
            SizedBox(width: 8.0),
            Text(
              "Sign in with Ahoge Account",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
      SizedBox(height: 16.0),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpPage()),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          fixedSize: WidgetStatePropertyAll(Size(500, 35)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.black,
            ),
            SizedBox(width: 8.0),
            Text(
              "Create new Ahoge Account",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
      SizedBox(height: 32.0),
      TextButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.grey),
          fixedSize: WidgetStatePropertyAll(Size(500, 35)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_to_drive,
              color: Colors.black,
            ),
            SizedBox(width: 8.0),
            Text(
              "Sign in with Google",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
      SizedBox(height: 8.0),
      Text(
        "Your device is not registered to Google Play Services",
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: Colors.grey),
      ),
      SizedBox(height: 16.0),
      FutureBuilder(
        future: isObsolete(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return Text(
              "This app version is marked as obsolete and no longer support our latest feature. Please update to the latest version!",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
            );
          } else {
            return SizedBox();
          }
        },
      )
    ],
  );
}
