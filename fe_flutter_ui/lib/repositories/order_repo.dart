// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/order.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:http/http.dart' as http;

import '../utils/list_item.dart';

class OrderRepo implements IOrder {
  String orderUrl = 'Orders';
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };

  @override
  Future<List<Order>> getOrder(String userId) async {
    final response =
        await http.get(Uri.parse('$host$orderUrl/$userId'), headers: _headers);
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);

      var listOrder = result.map((e) => Order.fromJson(e)).toList();

      return listOrder;
    } else if (response.statusCode == 404) {
      List<Order> listCart = [];
      print('error 404');
      return listCart;
    } else {
      throw Exception('Can\'t get provinces');
    }
  }

  @override
  Future<String> postOrder(Order order) async {
    var addToCart = "$host$orderUrl";
    var body = json.encode(order);
    print(body);

    var results = await http
        .post(Uri.parse(addToCart),
            body: body,
            headers: _headers,
            encoding: Encoding.getByName('utf-8'))
        .then((value) => value.statusCode);

    print(results);
    return 'false';
  }
}
