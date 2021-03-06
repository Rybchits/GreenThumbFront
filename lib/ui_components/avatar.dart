import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/domain/entities/user_class.dart';

class UserAvatar extends StatelessWidget {
  late final double _radius;
  final User _user;

  UserAvatar(this._user, String size, {Key? key}) : super(key: key) {
    switch (size) {
      case 'small':
        _radius = 28;
        break;
      case 'medium':
        _radius = 58;
        break;
      default:
        _radius = 219;
    }
  }

  @override
  Widget build(BuildContext context) {

    return CircleAvatar(
      radius: _radius,
      child: _user.urlAvatar == null ? Text(_user.name.toUpperCase()[0],
              style: TextStyle(color: Colors.white, fontSize: _radius/1.5)) : null,
      backgroundImage: _user.urlAvatar == null ? null : NetworkImage(_user.urlAvatar!),
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }
}
