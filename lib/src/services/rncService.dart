import 'package:dio/dio.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class RncService {
  var api_key = "";
  Dio _dio;
 

  Future<String> getRNC(int rnc) async {
    api_key = await Setting.getAPIKEY();
    var options = new BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 10 * 1000, // 60 seconds
      receiveTimeout: 60 * 1000, // 2min seconds
      headers: 
      {
        "API-KEY":api_key
      } 
      );
      
    _dio = new Dio(options);
    var urll = await Setting.getHost();
    final String baseURL = urll + "/";
    final String path = "rnc/get/" + rnc.toString();
    try {
      Response response = await _dio.get(baseURL + path);
      
      if (response.statusCode == 200){
        if (response.data['data'] != 'none') {
          return response.data['data'];
        }else {
          return 'void';
        }
      }else{
      
      }
    } catch (e) {
      return null;
    }
  }
}