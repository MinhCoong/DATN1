class Coupons {
  int? id;
  String? title;
  String? code;
  int? discount;
  String? description;
  String? startDate;
  String? endDate;
  int? point;
  int? minimumQuantity;
  int? minimumTotla;
  String? image;
  String? imageFile;
  bool? status;

  Coupons(
      {this.id,
      this.title,
      this.code,
      this.discount,
      this.description,
      this.startDate,
      this.endDate,
      this.point,
      this.minimumQuantity,
      this.minimumTotla,
      this.image,
      this.imageFile,
      this.status});

  Coupons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'];
    discount = json['discount'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    point = json['point'];
    minimumQuantity = json['minimumQuantity'];
    minimumTotla = json['minimumTotla'];
    image = json['image'];
    imageFile = json['imageFile'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['code'] = code;
    data['discount'] = discount;
    data['description'] = description;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['point'] = point;
    data['minimumQuantity'] = minimumQuantity;
    data['minimumTotla'] = minimumTotla;
    data['image'] = image;
    data['imageFile'] = imageFile;
    data['status'] = status;
    return data;
  }
}
