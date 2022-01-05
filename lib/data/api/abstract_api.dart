import 'package:green_thumb_mobile/data/dto_models/plant_request_model.dart';
import 'package:green_thumb_mobile/data/dto_models/space_model.dart';
import 'package:green_thumb_mobile/data/dto_models/space_request_model.dart';
import 'package:green_thumb_mobile/data/dto_models/user_edit_request_model.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';

abstract class Api {
  void logout();

  Future<void> signInRequest(String email, String password);

  Future<void> signUpRequest(String name, String email, String password);

  Future<User> getUserRequest(String? email);

  Future<void> wateringPlantsRequest(List<int> idsWateringPlants);

  Future<void> createSpaceRequest(SpaceRequestModel requestModel);

  Future<void> createPlantRequest(PlantRequestModel requestModel);

  Future<void> editUserRequest(int userId, UserEditRequestModel model);

  Future<void> editPlantRequest(PlantRequestModel model);

  // filters: all, own
  Future<List<SpaceModel>> getSpaceListRequest(String filters);

  Future<SpaceModel> getSpaceRequest(int spaceId);

  Future<void> editSpaceRequest(int spaceId, SpaceRequestModel model);

  Future<List<SpaceModel>> getUserInvitesRequest();

  Future<void> inviteInSpaceByEmail(String email, int spaceId);

  Future<void> setNotificationRequest(int spaceId, bool notificationState);

  Future<void> acceptInviteToSpace(int spaceId);

  Future<void> rejectInviteToSpace(int spaceId);
}