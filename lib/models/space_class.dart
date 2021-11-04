import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/models/plant_class.dart';
import 'package:green_thumb_mobile/models/user_class.dart';

abstract class Space {
  int _idCreator = 0;
  String _name = "";
  String? _imageUrl = "";

  String get name => _name;
  String? get imageUrl => _imageUrl;
  int get idCreator => _idCreator;
}


class SpaceCardInfo extends Space {
  List<String> _tags = [];
  int _numberPlants = 0;

  SpaceCardInfo(String name) {
    _name = name;
  }

  SpaceCardInfo.fullConstructor(int idCreator, String name, String? imageUrl,
      this._tags, this._numberPlants) {
    _idCreator = idCreator;
    _name = name;
    _imageUrl = imageUrl;
  }

  List<String> get tags => _tags;
  int get numberPlants => _numberPlants;
}


class SpaceCardContent extends Space {
  TimeOfDay _notificationTime = TimeOfDay(hour: 8, minute: 0);
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
