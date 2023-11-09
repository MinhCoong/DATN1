import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/productmrsoai.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';

import 'package:http/http.dart' as http;

import '../utils/list_item.dart';

class ProductRepo implements IProduct {
  static String products = 'product/Search';
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  @override
  Future<List<Products>> getProduct(String? productName) async {
    final response = await http.get(Uri.parse('$host$products?productName=$productName'), headers: _headers);
    List<Products> listProduct = [];

    if (response.statusCode == 200) {
      final List result = json.decode(response.body);

      listProduct = result.map((e) => Products.fromJson(e)).toList();
      return listProduct;
    } else if (response.statusCode == 404) {
      return listProduct;
    } else {
      throw Exception('Can\'t get provinces');
    }
  }
}
