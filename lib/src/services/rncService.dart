
import 'package:dio/dio.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class RncService {
  final Dio _dio = new Dio();
  Future<String> getRNC(int rnc) async {
    var urll = await Setting.getHost();
  final String baseURL =  urll +  ':' + Setting.GetPort() + "/";
  print(baseURL);
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
