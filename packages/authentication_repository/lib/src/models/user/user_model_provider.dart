import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';

class UserModelProvider extends ChangeNotifier {
  UserModel _user;

  UserModel get user => _user;

  set userSet(UserModel newUser) {
    assert(newUser != null);
    _user = newUser;
    notifyListeners();
  }

  void add(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
