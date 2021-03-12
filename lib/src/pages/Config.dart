import 'package:flutter/material.dart';
import 'package:ncf_flutter_app/src/widgets/drawer.dart';

class ConfigW extends StatefulWidget {
  ConfigW({Key key}) : super(key: key);

  @override
  _ConfigWState createState() => _ConfigWState();
}

class _ConfigWState extends State<ConfigW> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Hola estas en configuracion'),
      drawer: drawerW(),
      appBar: AppBar(title: Text('NCF')),
    );
  }
}
