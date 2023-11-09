class Addresses {
  int? id;
  String? userId;
  String? addrressValue;
  String? nameAddress;
  String? description;
  bool? status;

  Addresses(
      {this.id,
      this.userId,
      this.addrressValue,
      this.nameAddress,
      this.description,
      this.status});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    addrressValue = json['addrressValue'];
    nameAddress = json['nameAddress'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['addrressValue'] = addrressValue;
    data['nameAddress'] = nameAddress;
    data['description'] = description;
    data['status'] = status;
    return data;
  }
}
