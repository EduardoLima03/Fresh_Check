import 'package:coleta_de_validade_lj04/resources/save_user_resource.dart';
import 'package:coleta_de_validade_lj04/services/login_service.dart';

class LoginController{
  final SaveUserResource _saveUserResource = SaveUserResource();
  final LoginService _loginService = LoginService();

  login({required String email, required String password}){
    
  }
}