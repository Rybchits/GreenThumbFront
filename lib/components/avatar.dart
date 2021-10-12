import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  double _radius = 219;
  String _urlImage = '';

  UserAvatar(String urlImage, String size, {Key? key}) : super(key: key) {
    _urlImage = urlImage;

    switch (size){
      case 'small':
        _radius = 28;
        break;
      case 'medium':
        _radius = 64;
        break;
      default:
        _radius = 219;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _radius,
      foregroundImage: NetworkImage(_urlImage),
      backgroundImage: const AssetImage('assets/images/NoAvatarUser.jpg'),
    );
  }
}
