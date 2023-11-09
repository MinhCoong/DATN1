// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/favorite.dart';
import 'package:fe_flutter_ui/models/productmrsoai.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:http/http.dart' as http;

import '../utils/list_item.dart';

class FavoriteRepo implements IFavorite {
  String favoriteOfCus = 'Favorites';
  // static String host = 'https://192.168.2.24:8000/v1/api/';
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  @override
  Future<String> deleteFavorite(int id) async {
    final url = '$host$favoriteOfCus?Id=$id';

    try {
      var result = 'false';
      var x = await http.delete(Uri.parse(url), headers: _headers);
      print(x.statusCode);
      if (x.statusCode == 204) {
        result = 'true';
      }
      return result;
    } catch (e) {
      throw Exception('error $e');
    }
  }

  @override
  Future<List<Products>> getFavorite(String userId) async {
    if (userId == 'null') {
      List<Products> lstF = [];
      print("${userId}FavoriteUser Null");
      return lstF;
    }
    final response = await http.get(Uri.parse('$host$favoriteOfCus/$userId'), headers: _headers);
    print(response.request);
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);

      var listCart = result.map((e) => Products.fromJson(e)).toList();

      return listCart;
    } else if (response.statusCode == 404) {
      List<Products> listCart = [];
      print('error 404');
      return listCart;
    } else {
      List<Products> listCart = [];
      print('error 500');
      return listCart;
    }
  }

  @override
  Future<String> postCart(Favorite favorite) async {
    var addToCart = "$host$favoriteOfCus";
    var body = json.encode(favorite);
    print(body);
    var results = await http
        .post(Uri.parse(addToCart), body: body, headers: _headers, encoding: Encoding.getByName('utf-8'))
        .then((value) => value.statusCode);

    print(results);
    return 'false';
  }
}
