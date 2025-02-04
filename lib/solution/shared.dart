import 'package:picole/solution/tools.dart';
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

Future<void> setObsolete(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (status == true) {
    await prefs.setString('obsolete', 'true');
  } else {
    await prefs.setString('obsolete', 'false');
  }
}

Future<bool> isObsolete() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String status = prefs.getString('obsolete') ?? '';

  if (status == 'true') {
    return true;
  } else {
    return false;
  }
}

Future<void> setConfig(List<bool> config) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setStringList('config', toStringList(config));
}

Future<List<bool>> getConfig() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? status = prefs.getStringList('config') ?? ['true', 'true'];

  return toBoolList(status);
}
