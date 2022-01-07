import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';
import 'api_repository.dart';

class UserStore extends ChangeNotifier {
  APIRepository? _apiProvider;

  set api(APIRepository? apiRepository){
    _apiProvider = apiRepository;
  }

  User? _user;
  get user => _user;

  UserStore({ APIRepository? api }){
    _apiProvider = api;
  }

  Future<void> fetchUser(String? email) async{
    await _apiProvider?.api.getUserRequest(email).then((value) {
      _user = value;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async{
    await _apiProvider?.api.signInRequest(email, password).then((response) async{
      log('User authorized');
      await fetchUser(email);
    });
  }

  void logout(){
    _user = null;
    _apiProvider?.api.logout();
    notifyListeners();
  }
}