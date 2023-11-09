class Toppings {
  int? id;
  String? toppingName;
  int? price;
  String? image;
  bool? status;
  bool selected = false;

  Toppings(
      {this.id,
      this.toppingName,
      this.price,
      this.image,
      this.status,
      this.selected = false});

  Toppings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toppingName = json['toppingName'];
    price = json['price'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['toppingName'] = toppingName;
    data['price'] = price;
    data['image'] = image;
    data['status'] = status;
    return data;
  }
}
