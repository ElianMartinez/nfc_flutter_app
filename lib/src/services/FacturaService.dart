import 'package:dio/dio.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:intl/intl.dart';

class FacturaServices {
  Dio _dio;
  FacturaServices() {
    init();
  }
  void init() async {
    final String apiKey = await Setting.getAPIKEY();
    final String baseURL = await Setting.getHost() + ("/");
    BaseOptions options = new BaseOptions(
        baseUrl: (baseURL),
        receiveDataWhenStatusError: true,
        connectTimeout: 10 * 1000, // 60 seconds
        receiveTimeout: 60 * 1000,
        headers: {"API-KEY": apiKey} // 2min seconds
        );
    _dio = new Dio(options);
  }

  Future<DataTikect> Create_Factura(
      String rnc, String nombre, double monto, int idMP, int tiponcf) async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    final f = DateTime.now();
    final fecha = '$f';
    data = {
      "id_t_n": tiponcf,
      "rnc": rnc,
      "nombre": nombre,
      "monto": monto,
      "id_sucursal": int.parse(await Setting.getIdSucursal()),
      "id_metodo_pago": idMP,
      "fecha": fecha,
    };
    final String path = "factura/create";
    DataTikect res = DataTikect();
    try {
      Response response = await _dio.post(path, data: data);
      if (response.statusMessage != null) {
        if (response.statusCode == 200) {
          DateTime dt = new DateTime.now();
          String formattedDate = DateFormat('dd/MM/yyyy KK:mm a').format(dt);
          var fechaActual = formattedDate;
          var data = response.data['data'];
          res.nombreCliente = nombre;
          res.nombreEmpresa = data['company_name'];
          res.rncCliente = rnc;
          res.monto = monto;
          res.noFac = data['ID_ROW'];
          res.ncf = data['ncf_completo'];
          res.fecha = fechaActual;
          res.metPago = data['metodo_pago'];
          res.rncEmpresa = data['rnc_company'];
          res.direccionSucursal = data['direccion_sucursal'];
          res.telSucursal = data['telefono_sucursal'];
          res.nombreTipo = data['nametipo'];
          List<String> fven = data['fechaVence'].split("T")[0].split("-");
          res.fechaVence = '${fven[2]}/${fven[1]}/${fven[0]}';
          return res;
        } else {
          return null;
        }
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
