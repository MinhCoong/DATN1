import 'package:fe_flutter_ui/models/topping.dart';

class OrderdetailToppingList {
  int? id;
  int? toppingsId;
  Toppings? toppings;
  int? orderDetailId;
  String? orderDetail;
  bool? status;

  OrderdetailToppingList(
      {this.id,
      this.toppingsId,
      this.toppings,
      this.orderDetailId,
      this.orderDetail,
      this.status});

  OrderdetailToppingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toppingsId = json['toppingsId'];
    toppings =
        json['toppings'] != null ? Toppings.fromJson(json['toppings']) : null;
    orderDetailId = json['orderDetailId'];
    orderDetail = json['orderDetail'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['toppingsId'] = toppingsId;
    if (toppings != null) {
      data['toppings'] = toppings!.toJson();
    }
    data['orderDetailId'] = orderDetailId;
    data['orderDetail'] = orderDetail;
    data['status'] = status;
    return data;
  }
}

