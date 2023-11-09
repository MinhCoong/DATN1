class LoginNRegister {
  String? firstName;
  String? lastName;
  String? authenPhoneNumberId;
  String? phoneNumber;
  String? facebookUserId;
  String? googleUserId;
  String? email;
  String? avatar;

  LoginNRegister(
      {this.firstName,
      this.lastName,
      this.authenPhoneNumberId,
      this.phoneNumber,
      this.facebookUserId,
      this.googleUserId,
      this.email,
      this.avatar});

  LoginNRegister.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    authenPhoneNumberId = json['authenPhoneNumberId'];
    phoneNumber = json['phoneNumber'];
    facebookUserId = json['facebookUserId'];
    googleUserId = json['googleUserId'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['authenPhoneNumberId'] = authenPhoneNumberId;
    data['phoneNumber'] = phoneNumber;
    data['facebookUserId'] = facebookUserId;
    data['googleUserId'] = googleUserId;
    data['email'] = email;
    data['avatar'] = avatar;
    return data;
  }
}
