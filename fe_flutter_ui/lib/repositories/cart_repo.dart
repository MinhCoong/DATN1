// ignore_for_file: avoid_print, non_constant_identifier_names
import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/cart.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:http/http.dart' as http;

import '../utils/list_item.dart';

class CartRepo implements IcartRepo {
  String carts = 'Carts';
  // static String host = 'https://192.168.2.24:8000/v1/api/';
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };

  @override
  Future<String> deletedCart(int? Id, String userId) async {
    String del = 'Delete';
    String url = '';
    if (Id == null) {
      url = '$host$carts/$del?userId=$userId';
    } else {
      url = '$host$carts/$del?Id=$Id&userId=$userId';
    }

    try {
      var result = 'false';
      var x = await http.delete(Uri.parse(url), headers: _headers);
      if (x.statusCode == 204) {
        result = 'true';
      }
      return result;
    } catch (e) {
      throw Exception('error $e');
    }
  }

  @override
  Future<List<Cart>> getCart(String UserId) async {
    final response = await http.get(Uri.parse('$host$carts/$UserId'), headers: _headers);
    List<Cart> listCart = [];

    if (response.statusCode == 200) {
      final List result = json.decode(response.body);

      listCart = result.map((e) => Cart.fromJson(e)).toList();

      return listCart;
    } else if (response.statusCode == 404) {
      print('error 404');
      return listCart;
    } else {
      print('Can\'t get provinces');
      return listCart;
    }
  }

  @override
  Future<String> postCart(AddToCartModel cart) async {
    var addToCart = "$host$carts/AddToCart";
    var body = json.encode(cart);
    print(body);

    var results = await http
        .post(Uri.parse(addToCart), body: body, headers: _headers, encoding: Encoding.getByName('utf-8'))
        .then((value) => value.statusCode);

    print(results);
    return 'false';
  }
}
