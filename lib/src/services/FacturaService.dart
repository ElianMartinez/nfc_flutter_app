import 'package:dio/dio.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class FacturaServices {
  final Dio _dio = new Dio();
  Future<void> Create_Factura(int id, String rnc, String nombre, double monto,
      int id_s, int id_m_p) async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    // data = {
    //   "id_t_n": id,
    //   "rnc": rnc,
    //   "nombre": nombre,
    //   "monto": monto,
    //   "id_sucursal": id_s,
    //   "id_metodo_pago": id_m_p,
    // };
    data = {
      "id_t_n": 1,
      "rnc": 101070803,
      "nombre": "FULANITA KlK WAWAWA",
      "monto": 200.0,
      "id_sucursal": 1,
      "id_metodo_pago": 1,
    };

    final String baseURL =
        await Setting.getHost() + ':' + Setting.GetPort() + "/";
    final String path = "factura/create";

    try {
      print(baseURL + path);
      Response response = await _dio.post(baseURL + path, data: data);
      if (response.statusMessage != null) {
        if (response.statusCode == 200) {
          //El server manda respuesta
          print(response.data);
        }
      } else {
        //No encuentra el servidor 404;
        return false;
      }
    } catch (e) {
      print("error desconocido" + e);
    }
  }
}
