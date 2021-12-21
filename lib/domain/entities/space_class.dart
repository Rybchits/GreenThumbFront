import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/domain/entities/plant_class.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';

abstract class Space {
  int _idSpace = 0;
  String _name = "";
  String? _imageUrl = "";
  User _creator = User();
  List<String> _tags = [];

  String get name => _name;
  String? get imageUrl => _imageUrl;
  User get creator => _creator;
  int get id => _idSpace;
  List<String> get tags => _tags;
}


class SpaceCardInfo extends Space {
  int _numberPlants = 0;

  SpaceCardInfo.fullConstructor(int idSpace, User creator, String name, String? imageUrl,
      List<String> tags, this._numberPlants) {
    _tags = tags;
    _idSpace = idSpace;
    _creator = creator;
    _name = name;
    _imageUrl = imageUrl;
  }

  int get numberPlants => _numberPlants;


  factory SpaceCardInfo.fromJson(Map<String, dynamic> json){
    List<User> listUsers = (json['users'] as List).map((e) => User.fromJson(e)).toList();
    User creator = listUsers.firstWhere((item) => item.id == json['creatorId']);

    return SpaceCardInfo.fullConstructor(json['spaceId'], creator, json['name'],
      json['imageUrl'], json['tags'].cast<String>(), json['plants'].length);
  }
}


class SpaceDetails extends Space {
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  List<Plant> _plants = [];
  List<User> _otherParticipants = [];
  bool _notificationOn = false;


  SpaceDetails.fullConstructor(int id, String name, User creator, String? imageUrl,
      List<String> tags, this._notificationTime, this._plants, this._otherParticipants, this._notificationOn) {
    _idSpace = id;
    _name = name;
    _creator = creator;
    _imageUrl = imageUrl;
  }

  TimeOfDay get notificationTime => _notificationTime;
  List<Plant> get plants => _plants;
  List<User> get otherParticipants => _otherParticipants;
  bool get notificationOn => _notificationOn;


  factory SpaceDetails.fromJson(Map<String, dynamic> json){

    List<User> listUsers = (json['users'] as List).map((e) => User.fromJson(e)).toList();
    listUsers.sort((a, b) => a.name!.compareTo(b.name!));

    User creator = listUsers.firstWhere((item) => item.id == json['creatorId']);
    listUsers.removeWhere((item) => item.id == json['creatorId']);

    List<Plant> listPlants = (json['plants'] as List).map((e) => Plant.fromJson(e)).toList();
    listPlants.sort((a, b) => a.name.compareTo(b.name));

    List<String> tags = json['tags'].cast<String>();
    String? urlImage = json['imageUrl'];

    return SpaceDetails.fullConstructor(json['spaceId'], json['name'],
        creator,  urlImage, tags, const TimeOfDay(hour: 8, minute: 0),
        listPlants, listUsers, json['notificationEnabled']);
  }
}
