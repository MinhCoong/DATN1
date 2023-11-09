class RegistrationToken {
  int? id;
  String? deviceToken;
  String? userId;
  bool? status;

  RegistrationToken({this.id, this.deviceToken, this.userId, this.status});

  RegistrationToken.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceToken = json['deviceToken'];
    userId = json['userId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deviceToken'] = deviceToken;
    data['userId'] = userId;
    data['status'] = status;
    return data;
  }
}
