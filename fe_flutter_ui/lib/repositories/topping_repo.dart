// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/category.dart';
import 'package:fe_flutter_ui/models/topping.dart';
import 'package:fe_flutter_ui/models/topping_category.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:http/http.dart' as http;

import '../utils/list_item.dart';

class ToppingRepo implements IToppingNCategory {
  static String toppings = 'ToppingNCategories';
  static String tp = '/Topping';
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };

  @override
  Future<List<ToppingNCategory>> getTopping() async {
    final response = await http.get(
      Uri.parse(host + toppings),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);
      for (var element in result) {
        print(Categorys.fromJson(element));
      }

      var listCate = result.map((e) => ToppingNCategory.fromJson(e)).toList();

      return listCate;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Can\'t get provinces');
    }
  }

  @override
  Future<List<Toppings>> getListTopping() async {
    final response = await http.get(
      Uri.parse(host + toppings + tp),
      headers: _headers,
    );
     print(response.statusCode);
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);
      for (var element in result) {
        print(Categorys.fromJson(element));
      }

      var listTopping = result.map((e) => Toppings.fromJson(e)).toList();
     
      return listTopping;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      
      throw Exception('Can\'t get provinces');
    }
  }
}
