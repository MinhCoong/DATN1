import 'package:fe_flutter_ui/models/customer.dart';
import 'package:fe_flutter_ui/models/productmrsoai.dart';

class Favorite {
  int? id;
  String? userId;
  Customer? user;
  int? productId;
  Products? product;
  bool? status;

  Favorite(
      {this.id,
      this.userId,
      this.user,
      this.productId,
      this.product,
      this.status});

  Favorite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    user = json['user'] != null ? Customer.fromJson(json['user']) : null;
    productId = json['productId'];
    product =
        json['product'] != null ? Products.fromJson(json['product']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['productId'] = productId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['status'] = status;
    return data;
  }
}
