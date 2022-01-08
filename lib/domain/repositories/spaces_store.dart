import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/data/dto_models/plant_request_model.dart';
import 'package:green_thumb_mobile/data/dto_models/space_model.dart';
import 'package:green_thumb_mobile/data/dto_models/space_request_model.dart';
import 'package:green_thumb_mobile/domain/entities/space_class.dart';
import 'package:green_thumb_mobile/domain/repositories/api_repository.dart';

/// Хранилище пространств
/// Осуществляет запросы к серверу и сохраняет результаты
/// Осуществляет выдачу пространств относительно фильтров
class SpacesStore extends ChangeNotifier {
  APIRepository? _apiProvider;

  set api(APIRepository? apiRepository) {
    _apiProvider = apiRepository;
  }

  List<SpaceDetails> _spaces = [];

  SpacesStore({ APIRepository? api }) {
    _apiProvider = api;
  }

  List<SpaceDetails> get spaces => _spaces;

  // Получить все пространства авторизированного пользователя
  Future<void> fetchSpaces() async {
    List<SpaceModel> response = await _apiProvider?.api.getSpaceListRequest('all') ?? [];
    _spaces = response.map((e) => e.toModel()).toList();
    _spaces.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  // Добавить новое пространство
  Future<void> addNewSpace(SpaceRequestModel model) async {
    await _apiProvider?.api.createSpaceRequest(model).then((value) => fetchSpaces());
  }

  // Изменить существующее пространство
  Future<void> editExistSpace(int idSpace, SpaceRequestModel model) async {
    await _apiProvider?.api.editSpaceRequest(idSpace, model).then((value) => getSpaceFromApi(idSpace));
  }

  // Получить пространство по id и занести его в список всех пространств
  Future<SpaceDetails?> getSpaceFromApi(int id) async {
    SpaceDetails? space = (await _apiProvider?.api.getSpaceRequest(id))?.toModel();
    _spaces.forEach((element) => element.id == id ? space : element);
    _spaces.sort((a, b) => a.name.compareTo(b.name));
    return space;
  }

  // Пригласить пользователя в пространство
  Future<void> inviteUserInSpace(int idSpace, String userEmail) async{
    _apiProvider?.api.inviteInSpaceByEmail(userEmail, idSpace);
  }

  // Добавить растение в пространство
  Future<void> createPlantInSpace(PlantRequestModel requestModel) async{
    _apiProvider?.api.createPlantRequest(requestModel);
  }
  // Изменить растение в пространстве
  Future<void> updatePlantInSpace(PlantRequestModel requestModel) async{
    _apiProvider?.api.editPlantRequest(requestModel);
  }

  // Полить список растений
  Future<void> wateringPlantsInSpace(int idSpace, List<int> idsPlants) async {
    await _apiProvider?.api.wateringPlantsRequest(idsPlants);
  }

  // Установить уведомления для пространства
  Future<void> setSpaceNotification(int spaceId, bool value) async {
    await _apiProvider?.api.setNotificationRequest(spaceId, value);
  }
}