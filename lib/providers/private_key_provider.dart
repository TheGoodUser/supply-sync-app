import 'package:flutter/material.dart';

class PrivateKeyProvider extends ChangeNotifier {
  String? _privateKey;

  String? get privateKey => _privateKey;

  void setPrivateKey(String key) {
    _privateKey = key;
    notifyListeners();
  }
}