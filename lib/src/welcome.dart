import 'package:flutter/material.dart';
import 'package:picole/ui/ui_welcome.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return uiWelcomePage(context, this);
  }
}
