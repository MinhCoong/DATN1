import 'package:fe_flutter_ui/models/orderdetail_topping.dart';
import 'package:fe_flutter_ui/models/productmrsoai.dart';
import 'package:fe_flutter_ui/models/size.dart';

class OrderDetails {
  int? id;
  String? code;
  int? orderId;
  String? order;
  int? productId;
  Products? product;
  int? sizeId;
  Size? size;
  int? quantity;
  int? price;
  String? desciption;
  int? subtotal;
  List<OrderdetailToppingList>? orderdetailToppingList;

  OrderDetails(
      {this.id,
      this.code,
      this.orderId,
      this.order,
      this.productId,
      this.product,
      this.sizeId,
      this.size,
      this.quantity,
      this.price,
      this.desciption,
      this.subtotal,
      this.orderdetailToppingList});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    orderId = json['orderId'];
    order = json['order'];
    productId = json['productId'];
    product =
        json['product'] != null ? Products.fromJson(json['product']) : null;
    sizeId = json['sizeId'];
    size = json['size'] != null ? Size.fromJson(json['size']) : null;
    quantity = json['quantity'];
    price = json['price'];
    desciption = json['desciption'];
    subtotal = json['subtotal'];
    if (json['orderdetailToppingList'] != null) {
      orderdetailToppingList = <OrderdetailToppingList>[];
      json['orderdetailToppingList'].forEach((v) {
        orderdetailToppingList!.add(OrderdetailToppingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['orderId'] = orderId;
    data['order'] = order;
    data['productId'] = productId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['sizeId'] = sizeId;
    if (size != null) {
      data['size'] = size!.toJson();
    }
    data['quantity'] = quantity;
    data['price'] = price;
    data['desciption'] = desciption;
    data['subtotal'] = subtotal;
    if (orderdetailToppingList != null) {
      data['orderdetailToppingList'] =
          orderdetailToppingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
