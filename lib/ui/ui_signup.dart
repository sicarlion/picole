import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picole/src/signup.dart';

Widget uiSignUpPage(BuildContext context, SignUpPageState state) {
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
                child: AnimatedOpacity(
                  opacity: state.isProcessing ? 0.5 : 1,
                  duration: Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Left-aligned
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
        "Sign up for a new account",
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
      ),
      SizedBox(height: 8.0),
      Text(
        "Hello there! We humbly welcome you to our platform~",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    ],
  );
}

Widget _buildLoginForm(BuildContext context, SignUpPageState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildImageForm(context, state),
      TextField(
        controller: state.email,
        onChanged: (value) {
          state.setError(0);
        },
        decoration: InputDecoration(
          label: Text(
            'Email',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey),
          ),
          hintText: 'Your unique identity for login',
          hintStyle: TextStyle(color: Colors.grey),
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
          hintText: 'Your unique identity for login',
          hintStyle: TextStyle(color: Colors.grey),
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
        controller: state.display,
        onChanged: (value) {
          state.setError(0);
        },
        decoration: InputDecoration(
          label: Text(
            'Display Name',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey),
          ),
          hintText: 'How do you wish to be called?',
          hintStyle: TextStyle(color: Colors.grey),
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
          await state.userSignUp(context);
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
              "Sign Up",
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

Widget _buildImageForm(BuildContext context, SignUpPageState state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Profile Picture",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: GestureDetector(
          onTap: state.pickImage,
          child: Container(
            alignment: Alignment.center,
            width: 128,
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
                  : null,
            ),
          ),
        ),
      ),
    ],
  );
}
