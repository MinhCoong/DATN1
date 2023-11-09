import 'package:fe_flutter_ui/models/productmrsoai.dart';

class Categorys {
  int? id;
  String? categoryName;
  String? image;
  bool? status;
  List<Products>? products;

  Categorys(
      {this.id, this.categoryName, this.image, this.status, this.products});

  Categorys.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    image = json['image'];
    status = json['status'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categoryName'] = categoryName;
    data['image'] = image;
    data['status'] = status;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
