import 'package:shared_preferences/shared_preferences.dart';

class SaveUserResource{
  late SharedPreferences _preferences;

  SaveUserResource(){
    _initShared();
  }

  void _initShared() async{
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> saveLogin({required String token, required String name, required String occupation, required String shop}) async {
    await _preferences.setString('token', token);
    await _preferences.setString('name', name);
    await _preferences.setString('occupation', occupation);
    var isSave = await _preferences.setString('shop', shop);
    if(isSave){
      return true;
    }else{
      return false;
    }
  }

  Future<Map<String, String>> readLogin() async{
    var userMap = <String, String>{};
    userMap['token'] = await _preferences.getString('token').toString();
    userMap['name'] = await _preferences.getString('name').toString();
    userMap['occupation'] = _preferences.getString('occupation').toString();
    userMap['shop'] = _preferences.getString('shop').toString();

    return userMap;
  }

  String getToken(){
    var token = _preferences.getString('token').toString();

    return token.toString();
  }
}