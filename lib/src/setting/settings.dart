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
    final data =  preferences.getInt('id_sucuarsal');
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
}
