import 'package:flutter/material.dart';
import 'package:ncf_flutter_app/src/pages/FormNcf.dart';
import 'package:ncf_flutter_app/src/pages/Config.dart';
class drawerW extends StatefulWidget {
  drawerW({Key key}) : super(key: key);

  @override
  _drawerWState createState() => _drawerWState();
}

class _drawerWState extends State<drawerW> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text('PRUEBA'),
                accountEmail: Text('PRUEBA@GMAIL.COM')),
            ListTile(
              title: Text(
                'Formulario',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => FormNcf()))
              },
            ),
            ListTile(
              title: Text('Configuración', style: TextStyle(fontSize: 20.0)),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ConfigW()))
                },
            ),
          ],
        ),
      );
    
  }
}
