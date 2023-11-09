import 'dart:convert';
import 'dart:io';

import 'package:fe_flutter_ui/models/coupons.dart';
import 'package:fe_flutter_ui/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:fe_flutter_ui/repositories/interface.dart';

import '../models/slider.dart';
import '../utils/list_item.dart';

class NewsRepo implements IShared {
  static String slider = "getSlider";
  static String news = 'News';
  static String coupons = 'CouponCodes';
  static String host = '$endpoitMs/v1/api/';
  final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  @override
  Future<List<News>> getNew() async {
    final repon = await http.get(Uri.parse(host + news), headers: _headers);
    List<News> listNews = [];
    if (repon.statusCode == 200) {
      final List result = json.decode(repon.body);
      listNews = result.map((e) => News.fromJson(e)).toList();
      return listNews;
    } else if (repon.statusCode == 400) {
      return listNews;
    } else {
      throw Exception('Can\'t get provinces');
    }
  }

  @override
  Future<List<SliderMrSoai>> getSlider() async {
    final repon = await http.get(Uri.parse('$host$news/$slider'), headers: _headers);
    List<SliderMrSoai> lstSlider = [];
    if (repon.statusCode == 200) {
      final List result = json.decode(repon.body);
      lstSlider = result.map((e) => SliderMrSoai.fromJson(e)).toList();
      return lstSlider;
    } else if (repon.statusCode == 400) {
      return lstSlider;
    } else {
      throw Exception('Can\'t get provinces');
    }
  }

  @override
  Future<List<Coupons>> getListCoupons(String userId) async {
    final repon = await http.get(Uri.parse('$host$coupons/$userId'), headers: _headers);
    List<Coupons> listCoupons = [];
    if (repon.statusCode == 200) {
      final List result = json.decode(repon.body);
      listCoupons = result.map((e) => Coupons.fromJson(e)).toList();
      return listCoupons;
    } else if (repon.statusCode == 400) {
      return listCoupons;
    } else {
      return listCoupons;
    }
  }
}
