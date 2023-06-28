import 'dart:developer';

import 'package:coleta_de_validade_lj04/resources/save_user_resource.dart';
import 'package:coleta_de_validade_lj04/services/login_service.dart';

class LoginController{
  final SaveUserResource _saveUserResource = SaveUserResource();
  final LoginService _loginService = LoginService();

  String login({required String email, required String password}){
    var responseApi = _loginService.getLogin(email, password);
    log('TYPE LOGIN OBJETORE:${responseApi.runtimeType}');
    return "Succed";
  }

  Future<bool> verificarToken() async {
    var preferencesToken = await _saveUserResource.getToken();
    if (preferencesToken != null) {
      return true;
    } else {
      return false;
    }
  }
}