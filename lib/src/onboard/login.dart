import 'package:flutter/material.dart';
import 'package:picole/solution/shared.dart';
import 'package:picole/solution/database.dart';
import 'package:picole/src/main/discover.dart';
import 'package:picole/ui/onboard/ui_login.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool hasError = false;
  String errorMessage = '';

  void setError(int error) {
    setState(() {
      switch (error) {
        case 0:
          hasError = false;
        case 1:
          hasError = true;
          errorMessage = "No email has been provided.";
        case 2:
          hasError = true;
          errorMessage = "No password has been provided.";
        case 3:
          hasError = true;
          errorMessage = "No such account existed.";
      }
    });
  }

  void setMsg(supabase.PostgrestException error) {
    setState(() {
      errorMessage = "${error.code} - ${error.message}";
      hasError = true;
    });
  }

  Future<void> userLogin(context) async {
    if (username.text == '') {
      setError(1);
      return;
    } else if (password.text == '') {
      setError(2);
      return;
    }

    User? user;
    try {
      user = await Client.auth(username.text, password.text);
    } catch (e) {
      setError(3);
      return;
    }

    if (user != null) {
      await saveCredentials(username.text, password.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DiscoverPage()),
      );
      return;
    } else {
      setError(3);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return uiLoginPage(context, this);
  }
}
