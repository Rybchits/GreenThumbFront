import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/domain/entities/plant_class.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';

abstract class Space {
  int id = 0;
  String name = "";
  String? imageUrl = "";
  User creator = User();
  List<String> tags = [];
}


class SpaceDetails extends Space {
  TimeOfDay notificationTime = const TimeOfDay(hour: 8, minute: 0);
  List<Plant> plants = [];
  List<User> otherParticipants = [];
  bool notificationOn = false;

  SpaceDetails({ required int idSpace, required String nameSpace, required User creatorSpace,
    String? imageUrlSpace, List<String>? tagsSpace, TimeOfDay? notificationTimeSpace, List<Plant>? plantsSpace,
    List<User>? otherParticipantsSpace, bool? notificationOnSpace }) {

    id = idSpace;
    name = nameSpace;
    creator = creatorSpace;
    imageUrl = imageUrlSpace;
    tags = tagsSpace ?? [];
    notificationTime = notificationTimeSpace ?? const TimeOfDay(hour: 8, minute: 0);
    plants = plantsSpace ?? [];
    otherParticipants = otherParticipantsSpace ?? [];
    notificationOn = notificationOnSpace ?? false;
  }
}
