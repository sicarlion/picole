import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picole/src/login.dart';

Widget uiLoginPage(BuildContext context, state) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height, // Full screen height
              child: Padding(
                padding: EdgeInsets.all(48),
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
      Text(
        "Login to an existing account",
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
      ),
      SizedBox(height: 8.0),
      Text(
        "Ah I see, you are a person of culture as well. Welcome back~",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    ],
  );
}

Widget _buildLoginForm(BuildContext context, LoginPageState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        controller: state.username,
        onChanged: (value) {
          state.setError(0);
        },
        decoration: InputDecoration(
          label: Text(
            'Username',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 2.0, color: state.hasError ? Colors.red : Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.white),
          ),
        ),
        cursorColor: Colors.grey,
      ),
      SizedBox(height: 16.0),
      TextField(
        obscureText: true,
        controller: state.password,
        onChanged: (value) {
          state.setError(0);
        },
        decoration: InputDecoration(
          label: Text(
            'Password',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 2.0, color: state.hasError ? Colors.red : Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 2.0, color: Colors.white),
          ),
        ),
        cursorColor: Colors.grey,
      ),
      SizedBox(height: 32.0),
      TextButton(
        onPressed: () async {
          await state.userLogin(context);
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
              Icons.arrow_forward,
              color: Colors.black,
            ),
            SizedBox(width: 8.0),
            Text(
              "Sign in",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
      SizedBox(height: 16.0),
      if (state.hasError)
        Text(
          state.errorMessage,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
        ),
    ],
  );
}
