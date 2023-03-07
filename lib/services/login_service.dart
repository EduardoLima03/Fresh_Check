import 'package:coleta_de_validade_lj04/models/token_model.dart';
import 'package:coleta_de_validade_lj04/widgets/utils/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  var token = ValueNotifier('');
  var name = ValueNotifier('');
  var function = ValueNotifier('');

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  LoginService() {
    readToken();
  }

  Future<String?> getLogin(var email, var password) async {
    var url = Uri.parse('http://192.168.18.6/medeiros/public/api/login');
    try{
      var response = await http.post(url,
          headers: {"Accept": "application/json"},
          body: {"email": email.toString(), "password": password.toString()});
      if (response.statusCode == 200) {
        var _tUser = jsonDecode(response.body);
        TokenModel tokenModel = TokenModel.fromJson(_tUser);

        token.value = tokenModel.token!.toString();
        name.value = tokenModel.user!.nome.toString();
        function.value = tokenModel.user!.function.toString();
        saveToken(tokenModel.token.toString(), tokenModel.user!.nome.toString(),
            tokenModel.user!.function.toString(), email: email, password: password);
        return token.value.toString();
      } else {
        return "erro";
      }
    }catch(e){
      rethrow;
    }

  }


  void saveToken(String token, String name, String func,{String? email, String? password}) async {
    final SharedPreferences startPreferences = await _prefs;
    await startPreferences.setString('token', token);
    await startPreferences.setString('name', name);
    await startPreferences.setString('token', func);
    if(email != null && password != null){
      await startPreferences.setString('email', func);
      await startPreferences.setString('password', func);
    }
  }

  void readToken() async {
    final SharedPreferences startPreferences = await _prefs;
    token.value = startPreferences.getString('token').toString();
    name.value = startPreferences.getString('name').toString();
    function.value = startPreferences.getString('function').toString();
  }

  Future<bool> logout() async {
    try {
      _limpaRegistros();
    }catch(e){
      rethrow;
    }
    return true;
  }
  Future<void> _limpaRegistros() async {
    final SharedPreferences startPreferences = await _prefs;
    try{
      final removeName =  await startPreferences.remove('name');
      final removeFunction = await startPreferences.remove('function');
      final removeToken = await startPreferences.remove('token');
    }catch(e){
      throw e.runtimeType;
    }

    token.value = '';
    name.value = '';
    function.value = '';
  }

}
