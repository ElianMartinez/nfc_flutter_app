import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ncf_flutter_app/src/models/rncClass.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

Future<RNC> fetchRNC(int rnc) async {
 
  String url = Setting.GetHost() +":" + Setting.GetPort();
  print(url);
  final response =
      await http.get(Uri.http(url, "rnc/get/" + rnc.toString() + ''));
  print(response.body);
  if (response.statusCode == 200) {
    return RNC.fromJson(jsonDecode(response.body));
  } else {
    print('error');
    return RNC.error('none');
  }
}
