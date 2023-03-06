class TokenModel {
  String? token;
  User? user;

  TokenModel({this.token, this.user});

  TokenModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? nome;
  String? function;

  User({this.nome, this.function});

  User.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    function = json['function'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['function'] = this.function;
    return data;
  }
}