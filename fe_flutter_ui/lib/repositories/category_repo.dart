// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/category.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:http/http.dart' as http;

import '../utils/list_item.dart';

class CategoryRepo implements ICategoryRepo {
  static String categories = 'Categories';
  // static String host = 'https://192.168.2.24:8000/v1/api/';
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };

  @override
  Future<List<Categorys>> getCategories() async {
    final response = await http.get(Uri.parse(host + categories), headers: _headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);

      var listCate = result.map((e) => Categorys.fromJson(e)).toList();

      return listCate;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Can\'t get provinces');
    }
  }
}
