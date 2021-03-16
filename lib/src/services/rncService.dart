import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class RncService {
  final Dio _dio = new Dio();
  final String baseURL = Setting.GetHost() + ':' + Setting.GetPort() + "/";
  Future<String> getRNC(int rnc) async {
    final String path = "rnc/get/" + rnc.toString();
    try {
      print(baseURL + path);
      Response response = await _dio.get(baseURL + path);

      if (response.statusCode == 200) {
        if (response.data['data'] != 'none') {
          return response.data['data'];
        } else {
          return 'void';
        }
      }
    } catch (e) {
      return null;
    }
  }
}
