import 'dart:convert';

import 'package:flutter/material.dart';
import 'image_request_model.dart';

class SpaceRequestModel {
  String name;
  ImageRequestModel? imageAvatar;
  DateTime? notificationTime;
  String? tagsLabel;

  SpaceRequestModel({required this.name, this.imageAvatar, TimeOfDay? notificationTimeOfDay, List<String>? tags}){
    tagsLabel = tags == null? '' : tags.join(',');

    final now = DateTime.now();
    notificationTime = DateTime(now.year, now.month, now.day,
        notificationTimeOfDay?.hour ?? 8, notificationTimeOfDay?.minute ?? 0);
  }

  String toJson(){
    return jsonEncode({
      'spaceName': name,
      'notificationTime': notificationTime?.toIso8601String(),
      'tagsLabel': tagsLabel,
      'image': imageAvatar != null? { 'data': imageAvatar!.data, 'extension': imageAvatar!.extension } : null
    });
  }
}