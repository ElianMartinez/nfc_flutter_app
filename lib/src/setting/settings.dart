import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  static String port = "8999";
  static Future<String> getHost() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('ip');
    return data;
  }

  static Future<void> setHost(String ip) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('ip', ip);
  }

  static String GetPort() {
    return port;
  }

  static Future<String> getIdSucursal() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getInt('id_sucuarsal');
    return data.toString();
  }

  static Future<void> setIdSucursal(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('id_sucuarsal', id);
  }

  static Future<String> getNameSucursal() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('name_sucuarsal');
    return data;
  }

  static Future<void> setNameSucursal(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('name_sucuarsal', id);
  }

  //Datos de la impresora guardados en local storage.

  //PrinterName
  static Future<void> setPrinterName(String name) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("PrinterName", name);
  }

  static Future<String> getPrinterName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('PrinterName');
    return data;
  }

  //PrinteAddress
  static Future<void> setPrinteAddress(String addr) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("PrinteAddress", addr);
  }

  static Future<String> getPrinteAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('PrinteAddress');
    return data;
  }

  //PrinterType
  static Future<void> setPrinterType(int type) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt("PrinterType", type);
  }

  static Future<int> getPrinterType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getInt('PrinterType');
    return data;
  }
  
  //Setting API KEY
  static Future<void> setAPIKEY(String type) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("api-key", type);
  }

  static Future<String> getAPIKEY() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('api-key');
    return data;
  }

  //Setting API 
  static Future<void> setRecibo(String type) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString("last-recibo", type);
  }

  static Future<String> getRecibo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = preferences.getString('last-recibo');
    return data;
  }
}
