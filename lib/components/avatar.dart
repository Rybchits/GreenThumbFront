import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  double _radius = 219;
  String? _urlImage = '';

  UserAvatar(String? urlImage, String size, {Key? key}) : super(key: key) {
    _urlImage = urlImage;

    switch (size){
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
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: _radius/1.5,
      ),
      foregroundImage: _urlImage == null? null : NetworkImage(_urlImage!),
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }
}
