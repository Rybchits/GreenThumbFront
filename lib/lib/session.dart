import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = FlutterSecureStorage();

class Session {
  static Map<String, String> headers = {'Content-Type': 'application/json'};
  static const SERVER_IP = 'jenypc.ddns.net:3333';
  static bool initialized = false;

  static _initialize() async {
    var cookie = (await storage.read(key: 'cookie')) ?? '';
    print('init session $cookie');

    headers['cookie'] = cookie;
    initialized = true;
  }
  
  static Future<http.Response> get(Uri url) async {
    if(!initialized){
      await _initialize();
    }

    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return response;
  }

  static Future<http.Response> post(Uri url, dynamic data) async {
    if(!initialized){
      await _initialize();
    }
    
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    return response;
  }

  static void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      var cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      headers['cookie'] = cookie;
      storage.write(key: "cookie", value: cookie);
    }
  }

  static void removeCookie() {
    storage.delete(key: "cookie");
    headers['cookie'] = "";
  }
}

class UserIdentifyingData{

  static const String _keyEmail = 'email';
  static const String _keyPassword = 'password';

  static Future setUserIdentifyingData(String email, String password) async {
    await storage.write(key: _keyEmail, value: email);
    await storage.write(key: _keyPassword, value: password);
  }

  static Future<String?> getEmail() async {
    return await storage.read(key: _keyEmail);
  }

  static Future<String?> getPassword() async {
    return await storage.read(key: _keyPassword);
  }

  static void removeLastUser() {
    storage.delete(key: _keyEmail);
    storage.delete(key: _keyPassword);
  }

}
