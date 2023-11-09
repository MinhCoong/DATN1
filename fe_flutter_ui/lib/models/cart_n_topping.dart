import 'package:fe_flutter_ui/models/topping.dart';

class CartNToppings {
  int? id;
  int? toppingsId;
  Toppings? toppings;
  int? cartId;
  bool? status;

  CartNToppings(
      {this.id, this.toppingsId, this.toppings, this.cartId, this.status});

  CartNToppings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toppingsId = json['toppingsId'];
    toppings =
        json['toppings'] != null ? Toppings.fromJson(json['toppings']) : null;
    cartId = json['cartId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['toppingsId'] = toppingsId;
    if (toppings != null) {
      data['toppings'] = toppings!.toJson();
    }
    data['cartId'] = cartId;
    data['status'] = status;
    return data;
  }
}
