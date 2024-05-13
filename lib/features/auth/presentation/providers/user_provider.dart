import 'package:blackcoffer_test_assignment/features/auth/data/data_sources/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:blackcoffer_test_assignment/features/auth/data/models/user_model.dart' as model;
class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthServices _authMethods = AuthServices();

  model.User getUser() {
    return _user!;
  }

  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUserDetails();
    _user = user;
    print(_user!.username);
    notifyListeners();
  }
}