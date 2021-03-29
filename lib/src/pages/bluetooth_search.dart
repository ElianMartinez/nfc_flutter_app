import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
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
  BluetoothManager bluetoothManager = BluetoothManager.instance;
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
    });
    bluetoothManager.state.listen((val) {
      print('state = $val');
      if (!mounted) return;
      if (val == 12) {
        setState(() {
          statusMsg = null;
          colorState = Colors.blue;
        });
        initPrinter();
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
    bluetoothManager.stopScan();
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
          statusMsg != null ? errorBluetooth() : listaDevices(context),
          loader(),
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
    print(res);
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
        dataImpri =
            "Error del Printer. Por favor verifique que el Printer esté encendido. Si ya está encendido, entonces apaguelo y inicielo nuevamente.";
        colorState = Colors.red;
      });
    }
  }

  Widget loader() {
    var visibility = Visibility(
      visible: _request,
      child: Container(
        height: size.height,
        width: size.width,
        color: Color.fromRGBO(0, 0, 0, 0.7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 7.0,
            ),
            SizedBox(height: 20.0),
            Text('Por favor espere....',
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
    return visibility;
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
              StreamBuilder<List<BluetoothDevice>>(
                stream: bluetoothManager.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
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
                            trailing:
                                _device != null && _device.address == d.address
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : null,
                          ))
                      .toList(),
                ),
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
  void initPrinter() async {
    _request = true;
    await bluetoothManager.startScan(timeout: Duration(seconds: 4));
    bluetoothManager.scanResults.listen((val) {
      if (!mounted) return;
      setState(() => _devices = val);
      setState(() {
        statusMsg = null;
        colorState = Colors.blue;
      });
      if (_devices.isEmpty)
        setState(() {
          statusMsg = 'No hay dispositivos cerca!';
          colorState = Colors.orange;
        });
    });
    _request = false;
  }
}
