import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCredentials(name, password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('name', name);
  await prefs.setString('password', password);
}

Future<List<String>> loadCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String name = prefs.getString('name') ?? '';
  String pass = prefs.getString('password') ?? '';

  return [name, pass];
}
