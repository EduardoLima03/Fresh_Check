import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  var token = ValueNotifier('');
  late SharedPreferences _prefs;


  Future<String?> getLogin(var email, var password) async {
    var url = Uri.parse('http://192.168.18.6/medeiros/public/api/login');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {"email": email.toString(), "password": password.toString()});
    if(response.statusCode == 200){
      token.value = jsonDecode(response.body).toString();
      _saveToken(token.value);
      return token.value.toString();
    }else{
      return "erro";
    }
  }
  Future<void> _startPreferences() async{
    _prefs = await SharedPreferences.getInstance();
  }


  _saveToken(String value) async{
    _startPreferences();
    await _prefs.setString('token', value);
  }

  _readToken() async{
    _startPreferences();
    token.value = _prefs.getString('token').toString();
  }

}
