import 'package:fe_flutter_ui/models/topping.dart';

class ToppingNCategory {
  int? id;
  int? toppingsId;
  Toppings? toppings;
  int? categoryId;
  bool? status;

  ToppingNCategory(
      {this.id, this.toppingsId, this.toppings, this.categoryId, this.status});

  ToppingNCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toppingsId = json['toppingsId'];
    toppings =
        json['toppings'] != null ? Toppings.fromJson(json['toppings']) : null;
    categoryId = json['categoryId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['toppingsId'] = toppingsId;
    if (toppings != null) {
      data['toppings'] = toppings!.toJson();
    }
    data['categoryId'] = categoryId;
    data['status'] = status;
    return data;
  }
}
