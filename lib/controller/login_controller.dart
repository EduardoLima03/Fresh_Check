import 'dart:developer';

import 'package:coleta_de_validade_lj04/resources/save_user_resource.dart';
import 'package:coleta_de_validade_lj04/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/form_page.dart';
import '../resources/data/user_data_provider.dart';
import '../widgets/utils/snackbar_custom.dart';

class LoginController {
  final SaveUserResource _saveUserResource = SaveUserResource();
  final LoginService _loginService = LoginService();
  late final BuildContext _context;

  LoginController(BuildContext context) {
    _context = context;
  }

  login({required String email, required String password}) {
    try {
      var responseApi = _loginService.getLogin(email, password);
      log('TYPE LOGIN OBJETORE:${responseApi.runtimeType}');
      if (responseApi.runtimeType != String) {
        saveProvider(responseApi.token.toString(), name, occupation, shop)
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(_context,
            MaterialPageRoute(builder: (context) => const FormPage()));
      } else {
        if (responseApi == 'Erro') {
          // ignore: use_build_context_synchronously
          SnackbarCustom().show(_context, "Usuario invalido", Colors.red);
        }
        SnackbarCustom().show(_context, "Erro", Colors.red);
      }
    } catch (e) {
      SnackbarCustom().show(_context, "ERRO: ${e.runtimeType}", Colors.red);
    }
  }

  Future<bool> verificarToken() async {
    var preferencesToken = _saveUserResource.getToken();
    // ignore: unnecessary_null_comparison
    if (preferencesToken != null) {
      return true;
    } else {
      return false;
    }
  }

  bool saveProvider(String token, String name, String occupation, String shop){
    _context.read<UserDataProvider>().setAll(name: name, occupation: occupation, shop: shop, token: token);
    return true;
  }
}


