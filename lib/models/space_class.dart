import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/models/plant_class.dart';
import 'package:green_thumb_mobile/models/user_class.dart';

abstract class Space {
  int _idSpace = 0;
  String _name = "";
  String? _imageUrl = "";
  User _creator = User();

  String get name => _name;
  String? get imageUrl => _imageUrl;
  User get creator => _creator;
  int get id => _idSpace;
}


class SpaceCardInfo extends Space {
  List<String> _tags = [];
  int _numberPlants = 0;

  SpaceCardInfo.fullConstructor(int idSpace, User creator, String name, String? imageUrl,
      this._tags, this._numberPlants) {
    _idSpace = idSpace;
    _creator = creator;
    _name = name;
    _imageUrl = imageUrl;
  }

  List<String> get tags => _tags;
  int get numberPlants => _numberPlants;


  factory SpaceCardInfo.fromJson(Map<String, dynamic> json){
    List<User> listUsers = (json['users'] as List).map((e) => User.fromJson(e)).toList();
    User creator = listUsers.where((item) => item.id == json['creatorId']).toList().first;

    return SpaceCardInfo.fullConstructor(json['spaceId'], creator, json['name'],
      json['imageUrl'], json['tags'].cast<String>(), json['plants'].length);
  }
}


class SpaceCardContent extends Space {
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  List<Plant> _plants = [];
  List<User> _otherParticipants = [];
  bool _notificationOn = false;


  SpaceCardContent.fullConstructor(int id, String name, User creator, String? imageUrl,
      this._notificationTime, this._plants, this._otherParticipants, this._notificationOn) {
    _idSpace = id;
    _name = name;
    _creator = creator;
    _imageUrl = imageUrl;
  }

  TimeOfDay get notificationTime => _notificationTime;
  List<Plant> get plants => _plants;
  List<User> get otherParticipants => _otherParticipants;
  bool get notificationOn => _notificationOn;

  set notificationOn(bool value) => _notificationOn = value;
}
