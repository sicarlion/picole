import 'package:flutter/material.dart';
import 'package:picole/solution/database.dart';

class GlobalProvider extends ChangeNotifier {
  Post? _featured;
  User? _client;
  List<bool> config = [true, true];

  Post? get featured => _featured;
  User? get client => _client;

  void setFeatured(Post post) {
    _featured = post;
    notifyListeners();
  }

  void setClient(User? client) {
    _client = client;
    notifyListeners();
  }

  void setConfig(int index, bool newValue) {
    config[index] = newValue;
    notifyListeners();
  }

  void setConfigBulk(List<bool> newValue) {
    config = newValue;
    notifyListeners();
  }
}
