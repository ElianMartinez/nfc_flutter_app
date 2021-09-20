import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

import 'bluetooth_search.dart';

class History_Facture extends StatefulWidget {
  const History_Facture({Key key}) : super(key: key);
  @override
  _History_FactureState createState() => _History_FactureState();
}

class _History_FactureState extends State<History_Facture> {
  DataTikect dtt;
  Future<DataTikect> getTiket() async {
    var data = await Setting.getRecibo();
    DataTikect dt = DataTikect.fromJson(json.decode(data));
    return dt;
  }

  // String varl = "RD$";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Historial de Recibos"),
        ),
        body: Stack(children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100.0,
                child: Center(
                    child: Text(
                  'Historial',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900),
                )),
              ),
              Container(
                width: double.infinity,
                height: 35.0,
                color: Color.fromRGBO(145, 145, 145, 0.2),
                child: Center(
                  child: Text(
                    "Recibos Recientes",
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Color.fromRGBO(145, 145, 145, 1)),
                  ),
                ),
              ),
              FutureBuilder(
                future: getTiket(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                  }else{
                    dtt = snapshot.data;
                  return historyItem(context);
                  }
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget historyItem(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(245, 245, 245, 1),
          border:
              Border.all(width: 0.5, color: Color.fromRGBO(200, 200, 200, 1))),
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dtt.rncCliente,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          Text(
            dtt.nombreCliente,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          Text( "RD"+NumberFormat.simpleCurrency().format(dtt.monto),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          Text(
            dtt.fecha,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextButton(
              child: Row(
                children: [
                  Text(
                    "Print",
                    style: TextStyle(color: Colors.red, fontSize: 18.0),
                  ),
                  Icon(
                    Icons.print_outlined,
                    color: Colors.red,
                  )
                ],
              ),
              onPressed: () => showAlertDialog(context)),
        ],
      ),
    );
  }

  Widget showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Si"),
      onPressed: () {
        Navigator.of(context).pop();
         Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BluetoothSearch(

                )),
      );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Imprimir recibos"),
      content: Text("Quieres imprimir este recibo? "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
