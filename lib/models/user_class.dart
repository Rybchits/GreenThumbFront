import 'package:flutter/material.dart';

class User {
    int _id = 0;
    String? _name = "";
    String? _email = "";
    String? _urlAvatar = "";

    User(this._name, this._email, this._urlAvatar);

    String? get name => _name;
    String? get email => _email;
    String? get urlAvatar => _urlAvatar;
}