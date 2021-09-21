import 'package:flutter/material.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ncf_flutter_app/src/models/printClass.dart';


class PrintTicket extends StatefulWidget {
  final DataTikect dataTikect;
  PrintTicket({this.dataTikect, Key key}) : super(key: key);

  @override
  _PrintTicketState createState() => _PrintTicketState(this.dataTikect);
}

class _PrintTicketState extends State<PrintTicket> {
   final DataTikect dataTikect;
  _PrintTicketState(this.dataTikect);
  final printC = new PrintC();
 
  String _devicesMsg;
  Color colorState;

  @override
    void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void body() async {
    String valor = await printC.printT(dataTikect);
    Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Imprimir Tikect'),
        backgroundColor: colorState,
      ),
      body:  Container(
        child: StreamBuilder(
          stream: FlutterBlue.instance.state,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            BluetoothState a = snapshot.data;
            if (a.index == 4) {
              body();
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bluetooth_disabled,
                    color: Colors.red,
                    size: 100.0,
                  ),
                  Text("El Bluetooth está desconectado. Por favor Enciendalo."),
                ],
              ));
            }
          },
        ),
      ),
    );
  }


}
