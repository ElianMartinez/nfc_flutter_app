import 'package:dio/dio.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class FacturaServices {
  Dio _dio;
  FacturaServices() {
    init();
  }
  void init() async {
    final String baseURL =
        await Setting.getHost() + ':' + Setting.GetPort() + "/";
    BaseOptions options = new BaseOptions(
        baseUrl: (baseURL),
        receiveDataWhenStatusError: true,
        connectTimeout: 10 * 1000, // 60 seconds
        receiveTimeout: 60 * 1000 // 2min seconds
        );
    _dio = new Dio(options);
  }

  Future<DataTikect> Create_Factura(
      String rnc, String nombre, double monto, int id_m_p) async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data = {
      "id_t_n": 2,
      "rnc": rnc,
      "nombre": nombre,
      "monto": monto,
      "id_sucursal": int.parse(await Setting.getIdSucursal()),
      "id_metodo_pago": id_m_p,
    };
    final String path = "factura/create";
    DataTikect res = DataTikect();
    try {
      Response response = await _dio.post(path, data: data);
      if (response.statusMessage != null) {
        if (response.statusCode == 200) {
          var data = response.data['data'];
          //var fechaArray = data['fecha'].split("T")[0];
          res.nombreCliente = nombre;
          res.nombreEmpresa = data['company_name'];
          res.rncCliente = rnc;
          res.monto = monto;
          res.noFac = data['ID_ROW'];
          res.ncf = data['ncf_completo'];
          res.fecha = new DateTime.now();
          res.metPago = data['metodo_pago'];
          res.rncEmpresa = data['rnc_company'];
          res.direccionSucursal = data['direccion_sucursal'];
          res.telSucursal = data['telefono_sucursal'];
          res.nombreTipo = data['nametipo'];
          return res;
        }
      } else {
        //No encuentra el servidor 404;
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
