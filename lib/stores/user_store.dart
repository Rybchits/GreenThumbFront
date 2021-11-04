import 'package:flutter/cupertino.dart';
import 'package:green_thumb_mobile/models/user_class.dart';

class UserStore extends ChangeNotifier {
  User? _user;

  get user => _user;

  void setUser(User? newUser) {
    _user = newUser;
    notifyListeners();
  }
}