import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier{
  late String _token;
  late String _name;
  late String _occupation;
  late String _shop;

  String get name => _name;
  String get occupation => _occupation;
  String get shop => _shop;
  String get token => _token;

  set name(String value){
    _name = value;
    notifyListeners();
  }
  set occupation(String value){
    _occupation = value;
    notifyListeners();
  }
  set token(String value){
    _token = value;
    notifyListeners();
  }
  set shop(String value){
    _shop = value;
    notifyListeners();
  }

  void setAll({required String name, required String occupation, required String shop, required String token}){
    this.name = name;
    this.occupation = occupation;
    this.shop = shop;
    this.token = token;
  }
}