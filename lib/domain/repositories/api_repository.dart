import 'package:green_thumb_mobile/data/api/abstract_api.dart';
import 'package:green_thumb_mobile/data/api/local_api/local_api.dart';
import 'package:green_thumb_mobile/data/api/web_api/http_api.dart';

class APIRepository{
  bool useLocalImplementation = false;

  Api get api => useLocalImplementation? LocalApi() : HttpApi();

  void setLocalImplementation(bool value){
    useLocalImplementation = value;
  }
}