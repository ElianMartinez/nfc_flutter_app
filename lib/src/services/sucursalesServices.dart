import 'package:dio/dio.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class SucursalesServices {
  
  
  Future<bool> getSucursales(String ip) async {
    final String baseURL = ip + ':' + Setting.GetPort() + "/";
    BaseOptions options = new BaseOptions(
        baseUrl: (baseURL),
        receiveDataWhenStatusError: false,
        connectTimeout: 20 * 1000, // 60 seconds
        receiveTimeout: 60 * 1000 // 60 seconds
        );
    final Dio _dio = new Dio(options);
    
    final String path = "sucursales/";
    print(baseURL + path);
    try { 
      Response response = await _dio.get(baseURL + path);
      
        if (response.statusCode == 200) {
          if (response.data['res'] == 'ok') {
            Setting.setHost(ip);
            return true;
          }
        }
    }on DioError  catch (ex) {
      if(ex.type == DioErrorType.CONNECT_TIMEOUT){
        print("Time out");
        return false;
      }
      return false;
    }
  }

  Future<String> getSucursal(int id) async {
    final String baseURL =
        await Setting.getHost() + ':' + Setting.GetPort() + "/";
    final String path = "sucursales/get/" + id.toString();
     var api_key = await Setting.getAPIKEY();
     var options = new BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 10 * 1000, // 60 seconds
      receiveTimeout: 60 * 1000, // 2min seconds
      headers: 
      {
        "API-KEY":api_key
      } 
      );
    final Dio dio = new Dio(options);
    try {
      print(baseURL + path);
      Response response = await dio.get(path);
      if (response.statusCode == 200) {
        if (response.data['res'] == 'ok') {
          await Setting.setIdSucursal(id);
          print(response.data['data']);
          if (response.data['data'] != "ocupado") {
            await Setting.setNameSucursal(response.data['data']);
          }
          return response.data['data'];
        } else if (response.data['res'] == 'false') {
          return "ocupado";
        } else {
          return "error";
        }
      }
    } catch (e) {
      print("error");
    }
  }
}
