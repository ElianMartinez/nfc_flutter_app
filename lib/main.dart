import 'package:flutter/material.dart';
import 'package:ncf_flutter_app/src/pages/Config.dart';
import 'package:ncf_flutter_app/src/pages/FormNcf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'NCF APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/': (context) => FormNcf(),
        '/config' : (context) => ConfigW(),
      },
      initialRoute: '/',
    );
  }
}

