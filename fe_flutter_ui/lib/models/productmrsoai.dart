import 'package:fe_flutter_ui/models/price.dart';

class Products {
  int? id;
  String? productName;
  String? description;
  int? categoryId;
  String? image;
  bool isFavorite = false;
  bool? status;
  List<Prices>? prices;

  Products(
      {this.id,
      this.productName,
      this.description,
      this.categoryId,
      this.image,
      this.isFavorite = false,
      this.status,
      this.prices});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    description = json['description'];
    categoryId = json['categoryId'];
    image = json['image'];
    status = json['status'];
    if (json['prices'] != null) {
      prices = <Prices>[];
      json['prices'].forEach((v) {
        prices!.add(Prices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productName'] = productName;
    data['description'] = description;
    data['categoryId'] = categoryId;
    data['image'] = image;
    data['status'] = status;
    if (prices != null) {
      data['prices'] = prices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
