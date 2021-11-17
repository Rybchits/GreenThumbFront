import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:green_thumb_mobile/lib/session.dart';
import 'package:green_thumb_mobile/models/user_class.dart';

class UserStore extends ChangeNotifier {
  User? _user;
  bool loading = false;

  get user => _user;

  Future fetchUser(BuildContext context, String email) async{
    loading = true;

    Uri urlRequest = Uri.http("jenypc.ddns.net:3333", "/getUser", {'email': email});
    log(urlRequest.toString());
    var response = await Session.get(urlRequest);

    if (response.statusCode == 200){
      User userFromServer = User.fromJson(json.decode(response.body));
      _user = userFromServer;
    } else {
      Future.error ("Что-то пошло не так. Код ошибки: ${response.statusCode}");
    }

    loading = false;
  }

  void setUser(User? newUser) {
    _user = newUser;
    notifyListeners();
  }
}