import 'package:dio/dio.dart';
import 'package:ncf_flutter_app/src/models/Comprobantes_Models.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class ComprobanteServives {
  Dio _dio = null;

  Future<Comprobante> buscarComprobantes(String valor, bool isRNC) async {
    final String apiKey = await Setting.getAPIKEY();
    final String baseURL = await Setting.getHost();
    final String path = "comprobante/buscar";
    BaseOptions options = new BaseOptions(
        baseUrl: (baseURL + ("/")),
        receiveDataWhenStatusError: true,
        connectTimeout: 10 * 1000, // 60 seconds
        receiveTimeout: 60 * 1000,
        headers: {"API-KEY": apiKey} // 2min seconds
        );
    _dio = new Dio(options);

    final info = isRNC
        ? {
            "sucursalID": int.parse(await Setting.getIdSucursal()),
            "ncf": 0,
            "rnc": valor
          }
        : {
            "sucursalID": int.parse(await Setting.getIdSucursal()),
            "ncf": valor,
            "rnc": 0
          };

    try {
      final resp = await _dio.post(path, data: info);
      if (resp.data["res"] != "err") {
        return Comprobante.fromJson(resp.data);
      } else {
        return null;
      }
    } on DioError catch (ex) {
      if (ex.type == DioErrorType.RECEIVE_TIMEOUT) {
        print("Time out");
        return null;
      }
      return null;
    }
  }
}