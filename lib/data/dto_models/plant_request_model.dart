import 'dart:convert';

import 'package:green_thumb_mobile/domain/entities/plant_class.dart';
import 'image_request_model.dart';

class PlantRequestModel {
  int? spaceId;
  int? plantId;
  String? name;
  int? wateringPeriodDays;
  DateTime? wateringDate;
  String? group;
  ImageRequestModel? image;
  String? imageUrl;

  PlantRequestModel({this.plantId, this.spaceId, this.name, this.group, this.wateringPeriodDays, this.image});

  PlantRequestModel.fromApi(Map<String, dynamic> map) {
    spaceId = map['spaceId'];
    plantId = map['plantId'];
    wateringPeriodDays = map['wateringPeriodDays'];
    wateringDate = DateTime.parse(map['wateringDate']);
    name = map['plantName'];
    imageUrl = map['imageUrl'];
    group = map['group'];
    image = null;
  }

  String toJson(){
    return jsonEncode({
      'spaceId': spaceId,
      'plantId': plantId,
      'plantName': name,
      'wateringPeriodDays': wateringPeriodDays,
      'nextWateringDate': wateringDate?.toIso8601String(),
      'group': group,
      'image': image != null? { 'data': image!.data, 'extension': image!.extension } : null
    });
  }
}

extension PlantMapper on PlantRequestModel {
  Plant toModel() {

    // Todo control timezone
    // Calculate the next watering date (period addition and time zone offset)
    DateTime tempDate = wateringDate?.add(Duration(days: wateringPeriodDays ?? 0)) ?? DateTime.now();

    return Plant(
        id: plantId,
        name: name,
        group: group,
        wateringPeriodDays: wateringPeriodDays,
        dateOfNextWatering: tempDate,
        urlImage: imageUrl
    );
  }
}
