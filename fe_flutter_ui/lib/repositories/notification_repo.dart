// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/notification.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:http/http.dart' as http;

import '../utils/list_item.dart';

class NotificationRepo extends INotification {
  String notifi = 'Notifications/';
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  @override
  Future<List<Notifications>> getNotification(String userId) async {
    final response = await http.get(Uri.parse('$host$notifi$userId'), headers: _headers);
    List<Notifications> listNotify = [];
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List result = json.decode(response.body);

      listNotify = result.map((e) => Notifications.fromJson(e)).toList();

      return listNotify;
    } else if (response.statusCode == 404) {
      print('error 404');
      return listNotify;
    } else {
      print('Can\'t get provinces');
      return listNotify;
    }
  }

  @override
  Future<String> deleteNotify(int id) async {
    var x = 'Delete/';
    try {
      final response = await http.delete(Uri.parse('$host$notifi$x$id'));
      print(response.statusCode);
      var result = 'false';
      if (response.statusCode == 200) {
        result = "true";
      }
      return result;
    } catch (e) {
      throw Exception('error $e');
    }
  }

  @override
  Future<String> updateStatus(int id) async {
    var x = 'UpdateStatus/';

    try {
      final response = await http.put(Uri.parse('$host$notifi$x$id'));
      print(response.statusCode);
      var result = 'false';
      if (response.statusCode == 200) {
        result = "true";
      }
      return result;
    } catch (e) {
      throw Exception('error $e');
    }
  }
}
