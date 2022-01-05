import 'package:green_thumb_mobile/data/api/abstract_api.dart';
import 'package:green_thumb_mobile/data/dto_models/plant_request_model.dart';
import 'package:green_thumb_mobile/data/dto_models/space_model.dart';
import 'package:green_thumb_mobile/data/dto_models/space_request_model.dart';
import 'package:green_thumb_mobile/data/dto_models/user_edit_request_model.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';


// Todo add realization LocalApi
class LocalApi implements Api{
  @override
  Future<void> acceptInviteToSpace(int spaceId) {
    throw UnimplementedError();
  }

  @override
  Future<void> createPlantRequest(PlantRequestModel requestModel) {
    throw UnimplementedError();
  }

  @override
  Future<void> createSpaceRequest(SpaceRequestModel requestModel) {
    throw UnimplementedError();
  }

  @override
  Future<void> editPlantRequest(PlantRequestModel model) {
    throw UnimplementedError();
  }

  @override
  Future<void> editSpaceRequest(int spaceId, SpaceRequestModel model) {
    throw UnimplementedError();
  }

  @override
  Future<void> editUserRequest(int userId, UserEditRequestModel model) {
    throw UnimplementedError();
  }

  @override
  Future<List<SpaceModel>> getSpaceListRequest(String filters) {
    throw UnimplementedError();
  }

  @override
  Future<SpaceModel> getSpaceRequest(int spaceId) {
    throw UnimplementedError();
  }

  @override
  Future<List<SpaceModel>> getUserInvitesRequest() {
    throw UnimplementedError();
  }

  @override
  Future<User> getUserRequest(String? email) {
    throw UnimplementedError();
  }

  @override
  Future<void> inviteInSpaceByEmail(String email, int spaceId) {
    throw UnimplementedError();
  }

  @override
  void logout() {
  }

  @override
  Future<void> rejectInviteToSpace(int spaceId) {
    throw UnimplementedError();
  }

  @override
  Future<void> setNotificationRequest(int spaceId, bool notificationState) {
    throw UnimplementedError();
  }

  @override
  Future<void> signInRequest(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> signUpRequest(String name, String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> wateringPlantsRequest(List<int> idsWateringPlants) {
    throw UnimplementedError();
  }
}