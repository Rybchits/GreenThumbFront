import 'package:green_thumb_mobile/data/dto_models/image_request_model.dart';

class UserEditRequestModel {
  final String name;
  final ImageRequestModel? image;

  UserEditRequestModel({required this.name, this.image});
}