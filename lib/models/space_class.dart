import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/models/plant_class.dart';
import 'package:green_thumb_mobile/models/user_class.dart';

abstract class Space {
  int _idSpace = 0;
  int _idCreator = 0;
  String _name = "";
  String? _imageUrl = "";

  String get name => _name;
  String? get imageUrl => _imageUrl;
  int get idCreator => _idCreator;
  int get id => _idSpace;
}


class SpaceCardInfo extends Space {
  List<String> _tags = [];
  int _numberPlants = 0;
  String? _avatarCreator;

  SpaceCardInfo(String name) {
    _name = name;
  }

  SpaceCardInfo.fullConstructor(int idSpace, int idCreator, String name, String? imageUrl,
      this._tags, this._numberPlants, this._avatarCreator) {
    _idSpace = idSpace;
    _idCreator = idCreator;
    _name = name;
    _imageUrl = imageUrl;
  }

  List<String> get tags => _tags;
  int get numberPlants => _numberPlants;
  String? get avatarCreator => _avatarCreator;

  factory SpaceCardInfo.fromJson(Map<String, dynamic> json){

    String? imageCreator = json['users'].map((data) => User.fromJson(data))
        .toList().first.urlAvatar;

    return SpaceCardInfo.fullConstructor(json['spaceId'], json['creatorId'], json['name'],
      json['imageUrl'], json['tags'].cast<String>(), json['plants'].length, imageCreator);
  }
}


class SpaceCardContent extends Space {
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  List<Plant> _plants = [];
  List<User> _users = [];
  bool _notificationOn = false;

  SpaceCardContent(String name) {
    _name = name;
  }

  SpaceCardContent.fullConstructor(int idCreator, String name, String? imageUrl,
      this._notificationTime, this._plants, this._users, this._notificationOn) {
    _idCreator = idCreator;
    _name = name;
    _imageUrl = imageUrl;
  }

  TimeOfDay get notificationTime => _notificationTime;
  List<Plant> get plants => _plants;
  List<User> get users => _users;
  bool get notificationOn => _notificationOn;

  set notificationOn(bool value) => _notificationOn = value;
}
