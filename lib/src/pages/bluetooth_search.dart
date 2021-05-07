import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:ncf_flutter_app/src/models/Imprimir.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class BluetoothSearch extends StatefulWidget {
  final DataTikect dataTikect;
  BluetoothSearch({this.dataTikect = null, Key key}) : super(key: key);

  @override
  _BluetoothSearchState createState() => _BluetoothSearchState(this.dataTikect);
}

class _BluetoothSearchState extends State<BluetoothSearch> {
  final DataTikect dataTikect;
  _BluetoothSearchState(this.dataTikect);
  BlueThermalPrinter bluetoothManager = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices;
  BluetoothDevice _device = null;

  Color colorState = Colors.blue;
  String statusMsg = null;
  var _request = false;
  var size;
  String dataImpri = "";

  void begin() {
    setState(() {
      statusMsg = null;
      colorState = Colors.blue;
      _request = false;
    });
    bluetoothManager.onStateChanged().listen((val) {
      if (!mounted) return;
      if (val == 12) {
        setState(() {
          statusMsg = null;
          colorState = Colors.blue;
        });
      } else if (val == 10) {
        print('off');
        setState(() {
          statusMsg = 'Bluetooth Desconectado!  Por favor enciandalo';
          colorState = Colors.red;
        });
      }
    });
  }

  @override
  void initState() {
    begin();
    impresora(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorState,
        title: Text('Bluetooth Devices'),
      ),
      body: Stack(
        children: [
          statusMsg != null ? errorBluetooth() : listaDevices(context) 
        ],
      ),
    );
  }

  void impresora(BuildContext context) async {
    setState(() {
      _request = true;
    });
    var impresor = Imprimir(dataTikect);
    var res = await impresor.startPrint();
    setState(() {
      _request = false;
      dataImpri = res;

      colorState = Colors.blue;
    });
    if (res == "Success") {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _request = false;
        dataImpri = "Error del Printer. Por favor verifique que el Printer esté encendido o verifique que el bluetooth esté encendido. Si ya está encendido, entonces apaguelo y inicielo nuevamente.";
        colorState = Colors.red;
      });
    }
  }

  Widget errorBluetooth() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_disabled,
            size: 70.0,
            color: colorState,
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              statusMsg,
              style: TextStyle(fontSize: 18.0, color: colorState),
            ),
          ),
          Column(
            children: [
              RaisedButton(
                child: Icon(Icons.refresh),
                onPressed: () => begin(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget mesgPrint(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.print_disabled,
            size: 100.0,
            color: colorState,
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                dataImpri,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, color: colorState),
              ),
            ),
          ),
          Column(
            children: [
              RaisedButton(
                child: Icon(Icons.refresh),
                onPressed: () => impresora(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget listaDevices(BuildContext context) {
    return dataTikect != null
        ? mesgPrint(context)
        : Column(
            children: [
              FutureBuilder<List<BluetoothDevice>>(
                future: bluetoothManager.getBondedDevices(),
                initialData: [],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      children: snapshot.data
                          .map((d) => ListTile(
                                title: Text(d.name + " " + d.type.toString()),
                                leading: d.type == 3
                                    ? Icon(
                                        Icons.print,
                                        color: Colors.green,
                                        size: 30.0,
                                      )
                                    : Icon(Icons.device_unknown),
                                subtitle: Text(d.address),
                                onTap: () async {
                                  setState(() {
                                    _device = d;
                                  });
                                },
                                trailing: _device != null &&
                                        _device.address == d.address
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : null,
                              ))
                          .toList(),
                    );
                  }
                },
              ),
              Column(
                children: [
                  RaisedButton(
                    child: Icon(Icons.refresh),
                    onPressed: () => begin(),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Text('Guardar este Printer'),
                    onPressed: () => savePrinter(context),
                  ),
                ],
              )
            ],
          );
  }

  void savePrinter(BuildContext context) async {
    await Setting.setPrinterName(_device.name);
    await Setting.setPrinteAddress(_device.address);
    await Setting.setPrinterType(_device.type);

    Navigator.pop(context);
  }
}
