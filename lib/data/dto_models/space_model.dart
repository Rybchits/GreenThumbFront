import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/data/dto_models/plant_request_model.dart';
import 'package:green_thumb_mobile/domain/entities/space_class.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';

class SpaceModel {
  int? idSpace;
  int? idCreator;
  String? name;
  String? imageUrl;
  List<String>? tags;
  List<User>? users;
  List<PlantRequestModel>? plants;
  DateTime? notificationTime;
  bool? notificationEnabled;

  SpaceModel.fromApi(Map<String, dynamic> map) {
    idSpace = map['spaceId'];
    idCreator = map['creatorId'];
    name = map['name'];
    imageUrl = map['imageUrl'];
    tags = map['tags'].cast<String>();
    users = (map['users'] as List).map((e) => User.fromApi(e)).toList();
    notificationEnabled = map['notificationEnabled'];
    notificationTime = DateTime.parse(map['notificationTime']);
    plants = (map['plants'] as List).map((e) => PlantRequestModel.fromApi(e)).toList();
  }
}

extension SpaceMapper on SpaceModel{
  SpaceDetails toModel() {

    User? creatorOfSpace = users?.firstWhere((item) => item.id == idCreator);
    users?.removeWhere((item) => item.id == idCreator);

    TimeOfDay? notificationTimeOfSpace = notificationTime == null? null :
                            TimeOfDay(hour: notificationTime!.hour, minute: notificationTime!.minute);

    return SpaceDetails(
      idSpace: idSpace ?? 0,
      nameSpace: name ?? '',
      creatorSpace: creatorOfSpace ?? User(),
      imageUrlSpace: imageUrl,
      tagsSpace: tags,
      otherParticipantsSpace: users,
      plantsSpace: plants?.map((e) => e.toModel()).toList(),
      notificationOnSpace: notificationEnabled,
      notificationTimeSpace: notificationTimeOfSpace
    );
  }
}