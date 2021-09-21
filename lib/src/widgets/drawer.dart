import 'package:flutter/material.dart';

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
          SizedBox(
            height: 40.0,
          ),
          Center(
              child: Text(
            "NCF APP",
            style: TextStyle(
                fontSize: 30.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold),
          )),
          SizedBox(
            height: 40.0,
          ),
          
          SizedBox(
            height: 20.0,
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue),
            title: Text('Configuración',
                style: TextStyle(fontSize: 20.0, color: Colors.blue)),
            onTap: () => {Navigator.of(context).pushNamed('/pass')},
          ),
          SizedBox(
            height: 20.0,
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.blue),
            title: Text('Historial',
                style: TextStyle(fontSize: 20.0, color: Colors.blue)),
            onTap: () => {Navigator.of(context).pushNamed('/history')},
          ),
        ],
      ),
    );
  }
}
