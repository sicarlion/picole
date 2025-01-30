import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:picole/solution/provider.dart';
import 'package:picole/src/main/discover.dart';
import 'package:picole/solution/database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Database.init();
  debugPaintSizeEnabled = false;
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlobalProvider(),
      child: const Picole(),
    ),
  );
}

void resetSp() async {
  final sp = await SharedPreferences.getInstance();
  sp.clear();
}

class Picole extends StatelessWidget {
  const Picole({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picole',
      theme: ThemeData(
        textTheme: TextTheme(
          bodySmall: TextStyle(),
          bodyMedium: TextStyle(),
          bodyLarge: TextStyle(),
          titleSmall: TextStyle(),
          titleMedium: TextStyle(),
          titleLarge: TextStyle(),
          labelSmall: TextStyle(),
          labelMedium: TextStyle(),
          labelLarge: TextStyle(),
          displaySmall: TextStyle(),
          displayMedium: TextStyle(),
          displayLarge: TextStyle(),
          headlineSmall: TextStyle(),
          headlineMedium: TextStyle(),
          headlineLarge: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        fontFamily: "Questrial",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const DiscoverPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
