// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/customer.dart';
import 'package:fe_flutter_ui/models/login.dart';
import 'package:fe_flutter_ui/models/registrationtoken.dart';
import 'package:fe_flutter_ui/models/token.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:http/http.dart' as http;

import '../utils/list_item.dart';

class CustomerRepo implements ICustomerRepo {
  static String authentication = 'Authenticate/RegisterOrLoginCustomer';
  static String acountCustomer = 'AccountCustomers/GetCustomer';
  static String updateCustomer = 'AccountCustomers';
  static String regisToken = 'RegistrationTokens';
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };

  @override
  Future<String> deletedCustomer(String customer) {
    throw UnimplementedError();
  }

  @override
  Future<Customer> getCustomer(String userId) async {
    var uri = host + acountCustomer;
    Customer customerX = Customer();

    final response = await http.get(Uri.parse('$uri/$userId'), headers: _headers);
    print(response.request);
    if (response.statusCode == 200) {
      final cus = json.decode(response.body);
      customerX = Customer.fromJson(cus);
      return customerX;
    } else if (response.statusCode == 404) {
      print('error 404');
      return customerX;
    } else {
      throw Exception('Can\'t get provinces');
    }
  }

  @override
  Future<TokenRepo> postCustomer(LoginNRegister customer) async {
    var uri = host + authentication;
    var body = json.encode(customer);
    late var reponse = TokenRepo(token: "Null", expiration: "Null");

    var results = await http.post(Uri.parse(uri), body: body, headers: _headers, encoding: Encoding.getByName('utf-8'));
    print(results.request);
    // print(results.statusCode);

    if (results.body.isNotEmpty) {
      final jsonObject = json.decode(results.body);
      reponse = TokenRepo.fromJson(jsonObject);
    }

    print(reponse.token);
    return reponse;
  }

  @override
  Future<String> putCompleted(Customer customer) async {
    var uri = host + updateCustomer;
    var body = json.encode(customer);
    print(body);
    var repon = false;
    var result = await http.put(Uri.parse(uri), body: body, headers: _headers, encoding: Encoding.getByName('utf-8'));
    print(result.request);
    print(result.statusCode);

    if (result.statusCode == 200) {
      repon = true;
      return repon.toString();
    } else {
      return repon.toString();
    }
  }

  @override
  Future<String> postRegistrationToken(RegistrationToken registrationToken) async {
    var uri = host + regisToken;
    var body = json.encode(registrationToken);
    var repon = false;
    var result = await http.post(Uri.parse(uri), body: body, headers: _headers, encoding: Encoding.getByName('utf-8'));
    if (result.statusCode == 200) {
      repon = true;
      return repon.toString();
    } else {
      return repon.toString();
    }
  }
}
