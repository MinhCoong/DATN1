import 'package:fe_flutter_ui/models/size.dart';

class Prices {
  int? id;
  int? productId;
  int? sizeId;
  int? priceOfProduct;
  Size? size;

  Prices(
      {this.id, this.productId, this.sizeId, this.priceOfProduct, this.size});

  Prices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    sizeId = json['sizeId'];
    priceOfProduct = json['priceOfProduct'];
    size = json['size'] != null ? Size.fromJson(json['size']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['sizeId'] = sizeId;
    data['priceOfProduct'] = priceOfProduct;
    if (size != null) {
      data['size'] = size!.toJson();
    }
    return data;
  }
}
