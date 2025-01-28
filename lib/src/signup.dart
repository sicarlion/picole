import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:picole/tools/credentials.dart';
import 'package:picole/tools/database.dart';
import 'package:picole/src/discover.dart';
import 'package:picole/ui/ui_signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController display = TextEditingController();
  final TextEditingController password = TextEditingController();

  File? file;

  bool isProcessing = false;
  bool hasError = false;
  String errorMessage = '';

  void setError(int error) {
    setState(() {
      isProcessing = false;
      switch (error) {
        case 0:
          hasError = false;
        case 1:
          hasError = true;
          errorMessage = "You are not assigning any profile picture!";
        case 2:
          hasError = true;
          errorMessage = "No email were provided.";
        case 3:
          hasError = true;
          errorMessage = "No username were provided.";
        case 4:
          hasError = true;
          errorMessage =
              "Username can only use lowercase letter (a-z), underscore (_), and numbers (0-9).";
        case 5:
          hasError = true;
          errorMessage =
              "No display name were provided. You will be called with this name!";
        case 6:
          hasError = true;
          errorMessage = "No password were provided.";
        case 7:
          hasError = true;
          errorMessage = "Account with the same username might already exist.";
      }
    });
  }

  void setMsg(supabase.PostgrestException error) {
    setState(() {
      errorMessage = "${error.code} - ${error.message}";
      hasError = true;
    });
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    }
  }

  Future<void> userSignUp(context) async {
    setError(0);
    if (file == null) {
      setError(1);
      return;
    } else if (email.text == '') {
      setError(2);
      return;
    } else if (username.text == '') {
      setError(3);
      return;
    } else if (!RegExp(r'^[a-z0-9_]+$').hasMatch(username.text)) {
      setError(4);
      return;
    } else if (display.text == '') {
      setError(5);
      return;
    } else if (password.text == '') {
      setError(6);
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      await Client.sign(
          file!, email.text, username.text, display.text, password.text);

      await saveCredentials(username.text, password.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DiscoverPage()),
      );
      return;
    } catch (e) {
      setError(7);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return uiSignUpPage(context, this);
  }
}
