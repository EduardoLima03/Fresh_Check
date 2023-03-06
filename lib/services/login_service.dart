import 'package:coleta_de_validade_lj04/models/token_model.dart';
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
          tokenModel.user!.function.toString());
      return token.value.toString();
    } else {
      return "erro";
    }
  }

//TODO nao esta salvando, [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: LateInitializationError: Field '_prefs@42249577' has not been initialized.
  saveToken(String token, String name, String func) async {
    final SharedPreferences startPreferences = await _prefs;
    await startPreferences.setString('token', token);
    await startPreferences.setString('name', name);
    await startPreferences.setString('token', func);
  }

  readToken() async {
    final SharedPreferences startPreferences = await _prefs;
    token.value = startPreferences.getString('token').toString();
    name.value = startPreferences.getString('name').toString();
    function.value = startPreferences.getString('function').toString();
  }

  /*Future<bool> isToken(){

  }*/
}
