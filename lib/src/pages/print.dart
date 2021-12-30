import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:ncf_flutter_app/src/models/printClass.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class PrintTicket extends StatefulWidget {
  final DataTikect dataTikect;
  PrintTicket({this.dataTikect, Key key}) : super(key: key);

  @override
  _PrintTicketState createState() => _PrintTicketState(this.dataTikect);
}

class _PrintTicketState extends State<PrintTicket> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final DataTikect dataTikect;
  _PrintTicketState(this.dataTikect);
  final printC = new PrintC();

  String _devicesMsg;
  Color colorState;

  @override
  void initState() {
    super.initState();
    body();
  }
  void body() async {
      try {
        await printC.printT(dataTikect);
        Navigator.pop(context);
      } on Exception catch (_) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text(
                      "La impresora está desconectada. Quiere intentar de nuevo."),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          body();
                        },
                        child: Text("Si")),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("No"))
                  ],
                ));
      }
    }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Imprimir Tikect'),
        backgroundColor: colorState,
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
