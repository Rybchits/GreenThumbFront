import 'package:flutter/cupertino.dart';

class TitleLogo extends StatelessWidget {
  double _width = 122;
  double _height = 112;
  var titleStyle = const TextStyle();

  TitleLogo(String size, {Key? key}) : super(key: key) {
    _width = size == "small" ? 75 : 122;
    _height = size == "small" ? 68 : 112;
    titleStyle = TextStyle(
        fontSize: size == "small" ? 26.0 : 38.0, fontFamily: 'Montserrat',
        color: const Color(0xff000000));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
      Image(
        image: const AssetImage('assets/images/BigLogo.png'),
        width: _width,
        height: _height,
      ),
      Padding(padding: const EdgeInsets.only(bottom: 0),
          child: Text("GREEN\nTHUMB", style: titleStyle))]);
  }
}
