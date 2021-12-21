import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:green_thumb_mobile/domain/secure_storage.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';

class UserStore extends ChangeNotifier {
  User? _user;

  get user => _user;

  Future fetchUser(String email) async{

    Uri urlRequest = Uri.http(Session.SERVER_IP, "/getUser", {'email': email});
    log(urlRequest.toString());
    var response = await Session.get(urlRequest);

    if (response.statusCode == 200){
      User userFromServer = User.fromJson(json.decode(response.body));
      _user = userFromServer;
    } else {
      Future.error ("Что-то пошло не так. Код ошибки: ${response.statusCode}");
    }

    notifyListeners();
  }

  void setUser(User? newUser) {
    _user = newUser;
    notifyListeners();
  }
}