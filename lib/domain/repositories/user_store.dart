import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:green_thumb_mobile/data/dto_models/space_model.dart';
import 'package:green_thumb_mobile/domain/entities/space_class.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';
import 'api_repository.dart';

class UserStore extends ChangeNotifier {
  // Репозиторий в котором определяется каким api пользоваться
  APIRepository? _apiProvider;

  set api(APIRepository? apiRepository){
    _apiProvider = apiRepository;
  }

  // Информация об авторизированном пользователе
  User? _user;
  get user => _user;

  UserStore({ APIRepository? api }){
    _apiProvider = api;
  }

  // Получение информации о пользователе по его email
  Future<void> fetchUser(String? email) async{
    await _apiProvider?.api.getUserRequest(email).then((value) {
      _user = value;
      notifyListeners();
    });
  }

  // Авторизация пользователя
  Future<void> login(String email, String password) async{
    await _apiProvider?.api.signInRequest(email, password).then((response) async{
      log('User authorized');
      await fetchUser(email);
    });
  }

  // Регистрация пользователя
  Future<void> registration(String username, String email, String password) async{
    await _apiProvider?.api.signUpRequest(username, email, password);
  }

  // Получить список приглашений авторизированного пользователя
  Future<List<SpaceDetails>> getInvitesCurrentUser() async{
    List<SpaceModel>? invites = await _apiProvider?.api.getUserInvitesRequest();
    return invites?.map((e) => e.toModel()).toList() ?? [];
  }

  // Принять приглашение в пространство
  Future<void> acceptInviteToSpace(int inviteId) async {
    _apiProvider?.api.acceptInviteToSpace(inviteId);
  }

  // Отклонить приглашение в пространство
  Future<void> rejectInviteToSpace(int inviteId) async {
    _apiProvider?.api.rejectInviteToSpace(inviteId);
  }

  // Выйти из аккаунта (удалить информацию о зарегистрированном пользователе)
  void logout(){
    _user = null;
    _apiProvider?.api.logout();
    notifyListeners();
  }
}