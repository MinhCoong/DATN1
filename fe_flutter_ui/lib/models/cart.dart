import 'package:fe_flutter_ui/models/cart_n_topping.dart';
import 'package:fe_flutter_ui/models/customer.dart';
import 'package:fe_flutter_ui/models/productmrsoai.dart';

import 'size.dart';

class Cart {
  int? id;
  String? codeOfCart;
  String? userId;
  Customer? user;
  int? productId;
  Products? product;
  int? sizeId;
  Size? size;
  int? quantity;
  int? priceProduct;
  String? desciption;
  bool? status;
  List<CartNToppings>? cartNToppings;

  Cart(
      {this.id,
      this.codeOfCart,
      this.userId,
      this.user,
      this.productId,
      this.product,
      this.sizeId,
      this.size,
      this.quantity,
      this.priceProduct,
      this.desciption,
      this.status,
      this.cartNToppings});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codeOfCart = json['codeOfCart'];
    userId = json['userId'];
    user = json['user'] != null ? Customer.fromJson(json['user']) : null;
    productId = json['productId'];
    product =
        json['product'] != null ? Products.fromJson(json['product']) : null;
    sizeId = json['sizeId'];
    size = json['size'] != null ? Size.fromJson(json['size']) : null;
    quantity = json['quantity'];
    priceProduct = json['priceProduct'];
    desciption = json['desciption'];
    status = json['status'];
    if (json['cartNToppings'] != null) {
      cartNToppings = <CartNToppings>[];
      json['cartNToppings'].forEach((v) {
        cartNToppings!.add(CartNToppings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['codeOfCart'] = codeOfCart;
    data['userId'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['productId'] = productId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['sizeId'] = sizeId;
    if (size != null) {
      data['size'] = size!.toJson();
    }
    data['quantity'] = quantity;
    data['priceProduct'] = priceProduct;
    data['desciption'] = desciption;
    data['status'] = status;
    if (cartNToppings != null) {
      data['cartNToppings'] = cartNToppings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddToCartModel {
  String? userId;
  int? productId;
  int? quantity;
  int? sizeId;
  String? description;
  double? priceProduct;
  List<int>? toppingSelect;

  AddToCartModel(
      {this.userId,
      this.productId,
      this.quantity,
      this.sizeId,
      this.description,
      this.priceProduct,
      this.toppingSelect});

  AddToCartModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    productId = json['productId'];
    quantity = json['quantity'];
    sizeId = json['sizeId'];
    description = json['description'];
    priceProduct = json['priceProduct'];
    toppingSelect = json['toppingSelect'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['productId'] = productId;
    data['quantity'] = quantity;
    data['sizeId'] = sizeId;
    data['description'] = description;
    data['priceProduct'] = priceProduct;
    data['toppingSelect'] = toppingSelect;
    return data;
  }
}
