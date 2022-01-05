import 'dart:convert';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:green_thumb_mobile/data/api/web_api/error_interceptor.dart';
import 'package:green_thumb_mobile/data/dto_models/plant_request_model.dart';
import 'package:green_thumb_mobile/data/dto_models/space_model.dart';
import 'package:green_thumb_mobile/data/dto_models/space_request_model.dart';
import 'package:green_thumb_mobile/data/dto_models/user_edit_request_model.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';
import 'package:dio/dio.dart';
import '../abstract_api.dart';


/// Особенности сервера
/// - Изображения передаются в виде относительного пути на сервере
///     /spaceLogo/1.jpg
///     Для доступа к изображению необходимо вначале пути добавить домен
///     Example: http://10.0.2.2:3333/spaceLogo/1.jpg
class HttpApi implements Api{

  static const serverIp = 'http://10.0.2.2:3333';   // Original: http://jenypc.ddns.net:3333
  static final _cookieJar = CookieJar();
  final _dio = createDio();


  static Dio createDio() {
    var dio = Dio(
        BaseOptions(
          baseUrl: serverIp,
          receiveTimeout: 15000, // 15 seconds
          connectTimeout: 15000,
          sendTimeout: 15000,
          headers: {'Content-Type': 'application/json'},
        )
    );

    dio.interceptors.addAll({ErrorInterceptors(dio), CookieManager(_cookieJar)});
    return dio;
  }

  @override
  void logout() {
    _cookieJar.deleteAll();
  }

  @override
  Future<List<SpaceModel>> getSpaceListRequest(String filters) async{
    final Response response = await _dio.get('/getSpaces', queryParameters: {'filter': filters});

    if (response.statusCode == 200) {
      var result = response.data as List<dynamic>;
      List<SpaceModel> spaceList = result.map((data) => SpaceModel.fromApi(data)).toList();

      // Преобразование путей изображений
      for (var spaceCurrent in spaceList) {
        spaceCurrent.imageUrl = spaceCurrent.imageUrl == null? null : serverIp + spaceCurrent.imageUrl!;

        spaceCurrent.users?.forEach((userInSpace) {
          userInSpace.urlAvatar = userInSpace.urlAvatar == null? null : serverIp + userInSpace.urlAvatar!;
        });
        
        spaceCurrent.plants?.forEach((plantInSpace) {
          plantInSpace.imageUrl = plantInSpace.imageUrl == null? null : serverIp + plantInSpace.imageUrl!;
        });
      }

      return spaceList;
    }
    return Future.error('Ошибка при получении пространств', StackTrace.current);
  }


  @override
  Future<SpaceModel> getSpaceRequest(int spaceId) async{
    final response = await _dio.get('/getSpace', queryParameters:{'spaceId': spaceId.toString()});

    if (response.statusCode == 200) {
      var space = SpaceModel.fromApi(response.data as Map<String, dynamic>);

      // Преобразование путей изображений
      space.imageUrl = space.imageUrl == null? null : serverIp + space.imageUrl!;

      space.users?.forEach((userInSpace) {
        userInSpace.urlAvatar = userInSpace.urlAvatar == null? null : serverIp + userInSpace.urlAvatar!;
      });

      space.plants?.forEach((plantInSpace) {
        plantInSpace.imageUrl = plantInSpace.imageUrl == null? null : serverIp + plantInSpace.imageUrl!;
      });

      return space;
    }
    return Future.error('Ошибка при получении информации о пространстве', StackTrace.current);
  }


  /// Получить данные о пользователе по электронной почте, если она равна нулю - по кукам
  /// email - электронная почта пользователя
  /// return - данные о пользователе
  @override
  Future<User> getUserRequest(String? email) async{
    final Response response;

    if (email == null) {
      response = await _dio.get("/getOurUser");
    } else {
      response = await _dio.get("/getUser", queryParameters: {'email': email});
    }

    if (response.statusCode == 200) {
      User userFromServer = User.fromApi(response.data);
      userFromServer.urlAvatar = userFromServer.urlAvatar == null? null : serverIp + userFromServer.urlAvatar!;
      return userFromServer;
    }

    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }


  @override
  Future<void> signInRequest(String email, String password) async{
    final Response response = await _dio.post('/auth', data: <String, String>{'email': email, 'password': password});

    if (response.statusCode == 200) {
      return Future.value();
    }

    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }


  @override
  Future<void> signUpRequest(String name, String email, String password) async{
    final Response response = await _dio.post('/register',
        data: jsonEncode(<String, String>{'name': name, 'email': email, 'password': password}));

    if (response.statusCode == 200) {
      return Future.value();
    }

    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }


  @override
  Future<void> wateringPlantsRequest(List<int> idsWateringPlants) async{
    final Response response = await _dio.post('/wateringPlants', data: json.encode({'plantsId': idsWateringPlants}));

    if (response.statusCode == 200) {
      return Future.value();
    }

    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }


  @override
  Future<List<SpaceModel>> getUserInvitesRequest() async{
    final response = await _dio.get('/getUserInvites');

    if (response.statusCode == 200) {
        List<SpaceModel> spaceInvitesList = (response.data as List).map((data) => SpaceModel.fromApi(data)).toList();

        // Преобразование путей изображений
        for (var spaceInvite in spaceInvitesList) {
          spaceInvite.imageUrl = spaceInvite.imageUrl == null? null : serverIp + spaceInvite.imageUrl!;

          spaceInvite.users?.forEach((userInSpace) {
            userInSpace.urlAvatar = userInSpace.urlAvatar == null? null : serverIp + userInSpace.urlAvatar!;
          });

          spaceInvite.plants?.forEach((plantInSpace) {
            plantInSpace.imageUrl = plantInSpace.imageUrl == null? null : serverIp + plantInSpace.imageUrl!;
          });
        }

        return spaceInvitesList;
    }

    return Future.error('Ошибка при получении приглашений', StackTrace.current);
  }


  @override
  Future<void> setNotificationRequest(int spaceId, bool notificationState) async{
    final response = await _dio.post('/setNotification',
        queryParameters: {'spaceId': spaceId.toString(), 'state': (notificationState).toString()});

    if (response.statusCode == 200) {
      return Future.value();
    }

    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }

  @override
  Future<void> createPlantRequest(PlantRequestModel requestModel) async{
    final response = await _dio.post('/createPlant', data: requestModel.toJson());

    if (response.statusCode == 200) {
      return Future.value();
    }

    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }

  @override
  Future<void> createSpaceRequest(SpaceRequestModel requestModel) async{
    final response = await _dio.post('/createSpace', data: requestModel.toJson());

    if (response.statusCode == 200) {
      return Future.value();
    }

    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }

  @override
  Future<void> editPlantRequest(PlantRequestModel model) async{
    final response = await _dio.post('/editPlant', queryParameters: {'plantId': model.plantId},
        data: model.toJson());

    if (response.statusCode == 200) {
      return Future.value();
    }

    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }


  @override
  Future<void> editSpaceRequest(int spaceId, SpaceRequestModel model) async{
    final response = await _dio.post('/editSpace', queryParameters: {'spaceId': spaceId.toString()},
        data: model.toJson());

    switch(response.statusCode) {
      case 200:
        return Future.value();
      case 400:
        return Future.error("Неверно указаны параметры", StackTrace.current);
    }
    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }


  @override
  Future<void> inviteInSpaceByEmail(String email, int spaceId) async{
    final response = await _dio.post('/inviteInSpaceByEmail', data: json.encode({'spaceId': spaceId, 'email': email}));

    if (response.statusCode == 200) {
      return Future.value();
    }

    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }


  @override
  Future<void> editUserRequest(int userId, UserEditRequestModel model) async{
    throw UnimplementedError();
  }


  @override
  Future<void> acceptInviteToSpace(int spaceId) async{
    final response = await _dio.post('/acceptInviteToSpace', queryParameters:{'spaceId': spaceId.toString()});

    if (response.statusCode == 200){
      return Future.value();
    }
    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }


  @override
  Future<void> rejectInviteToSpace(int spaceId) async{
    final response = await _dio.post('/rejectInviteToSpace', queryParameters:{'spaceId': spaceId.toString()});

    if (response.statusCode == 200){
      return Future.value();
    }
    return Future.error('Что-то пошло не так... Попробуйте позже', StackTrace.current);
  }
}