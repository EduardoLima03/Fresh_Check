import 'package:coleta_de_validade_lj04/models/token_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginService {

  Future<Object> getLogin(var email, var password) async {
    var url = Uri.parse('http://192.168.18.6/medeiros/public/api/login');
    try{
      var response = await http.post(url,
          headers: {"Accept": "application/json"},
          body: {"email": email.toString(), "password": password.toString()});
      if (response.statusCode == 200) {
        var tUser = jsonDecode(response.body);
        TokenModel tokenModel = TokenModel.fromJson(tUser);
        return tokenModel;
      } else {
        return "erro";
      }
    }catch(e){
      rethrow;
    }
  }


  Future<bool> logout() async {
    try {
    }catch(e){
      rethrow;
    }
    return true;
  }

}
