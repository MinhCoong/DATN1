// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/address.dart';
import 'package:http/http.dart' as http;
import 'package:fe_flutter_ui/repositories/interface.dart';

import '../utils/list_item.dart';

class AddressRepo implements IAddress {
  String addressX = "Addresses";
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final Map<String, String> _headers2 = {
    HttpHeaders.acceptHeader: "text/plain",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  @override
  Future<String> deleteAddress(int id) async {
    var uri = '$host$addressX/$id';
    try {
      var result = 'false';
      var x = await http.delete(Uri.parse(uri), headers: _headers);
      if (x.statusCode == 204) {
        result = true.toString();
      }
      return result;
    } catch (e) {
      throw Exception("error $e");
    }
  }

  @override
  Future<List<Addresses>> getAddress(String userId) async {
    var uri = '$host$addressX/$userId';
    final response = await http.get(Uri.parse(uri), headers: _headers2);
    List<Addresses> listAddress = [];

    if (response.statusCode == 200) {
      final List result = json.decode(response.body);

      listAddress = result.map((e) => Addresses.fromJson(e)).toList();

      return listAddress;
    } else if (response.statusCode == 404) {
      print('error 404');
      return listAddress;
    } else {
      throw Exception('Can\'t get provinces');
    }
  }

  @override
  Future<String> postAddress(Addresses address) async {
    var uri = host + addressX;
    var body = json.encode(address);

    print(body);

    var results = await http
        .post(Uri.parse(uri),
            body: body,
            headers: _headers2,
            encoding: Encoding.getByName('utf-8'))
        .then((value) => value.statusCode);
    print(results);
    return results.toString();
  }

  @override
  Future<String> updateAddress(int id, Addresses address) async {
    var updateAddress = 'UpdateAddress/';
    var uri = '$host$addressX/$updateAddress$id';
    var body = json.encode(address);
    print(body);
    var rsults = await http
        .put(Uri.parse(uri),
            body: body,
            headers: _headers,
            encoding: Encoding.getByName('utf-8'))
        .then((value) => value.statusCode);
    print(uri);
    print(rsults);
    return rsults.toString();
  }
}
