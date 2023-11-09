class Customer {
  String? id;
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? facebookUserId;
  String? googleUserId;
  int? point;
  String? avatar;
  String? sex;
  String? dateOfBirth;
  String? registerDatetime;
  bool? status;

  Customer(
      {this.id,
      this.email,
      this.phoneNumber,
      this.firstName,
      this.lastName,
      this.facebookUserId,
      this.googleUserId,
      this.point,
      this.avatar,
      this.sex,
      this.dateOfBirth,
      this.registerDatetime,
      this.status});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    facebookUserId = json['facebookUserId'];
    googleUserId = json['googleUserId'];
    point = json['point'];
    avatar = json['avatar'];
    sex = json['sex'];
    dateOfBirth = json['dateOfBirth'];
    registerDatetime = json['registerDatetime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['facebookUserId'] = facebookUserId;
    data['googleUserId'] = googleUserId;
    data['point'] = point;
    data['avatar'] = avatar;
    data['sex'] = sex;
    data['dateOfBirth'] = dateOfBirth;
    data['registerDatetime'] = registerDatetime;
    data['status'] = status;
    return data;
  }
}