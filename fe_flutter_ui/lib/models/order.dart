import 'package:fe_flutter_ui/models/customer.dart';

import 'coupons.dart';
import 'oderdetails.dart';

class Order {
  int? id;
  String? code;
  String? userId;
  Customer? user;
  int? couponsId;
  Coupons? coupons;
  String? orderDate;
  String? consigneePhoneNumber;
  String? consigneeName;
  String? deliveryMethod;
  String? deliveryTime;
  String? consigneeAddress;
  String? paymentMethod;
  num? total;
  int? deliveryCharges;
  int? orderStatus;
  List<OrderDetails>? orderDetails;

  Order(
      {this.id,
      this.code,
      this.userId,
      this.user,
      this.couponsId,
      this.coupons,
      this.orderDate,
      this.consigneePhoneNumber,
      this.consigneeName,
      this.deliveryMethod,
      this.deliveryTime,
      this.consigneeAddress,
      this.paymentMethod,
      this.total,
      this.deliveryCharges,
      this.orderStatus,
      this.orderDetails});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['userId'];
    user = json['user'] != null ? Customer.fromJson(json['user']) : null;
    couponsId = json['couponsId'];
    coupons = json['coupons'] != null ? Coupons.fromJson(json['coupons']) : null;
    orderDate = json['orderDate'];
    consigneePhoneNumber = json['consigneePhoneNumber'];
    consigneeName = json['consigneeName'];
    deliveryMethod = json['deliveryMethod'];
    deliveryTime = json['deliveryTime'];
    consigneeAddress = json['consigneeAddress'];
    paymentMethod = json['paymentMethod'];
    total = json['total'];
    deliveryCharges = json['deliveryCharges'];
    orderStatus = json['orderStatus'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['userId'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['couponsId'] = couponsId;
    if (coupons != null) {
      data['coupons'] = coupons!.toJson();
    }
    data['orderDate'] = orderDate;
    data['consigneePhoneNumber'] = consigneePhoneNumber;
    data['consigneeName'] = consigneeName;
    data['deliveryMethod'] = deliveryMethod;
    data['deliveryTime'] = deliveryTime;
    data['consigneeAddress'] = consigneeAddress;
    data['paymentMethod'] = paymentMethod;
    data['total'] = total;
    data['deliveryCharges'] = deliveryCharges;
    data['orderStatus'] = orderStatus;
    if (orderDetails != null) {
      data['orderDetails'] = orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
