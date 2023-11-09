class TokenRepo {
  String? token;
  String? expiration;

  TokenRepo({this.token, this.expiration});

  TokenRepo.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expiration'] = expiration;
    return data;
  }
}
