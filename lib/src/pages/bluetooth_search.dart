import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class BluetoothSearch extends StatefulWidget {
  @override
  _BluetoothSearchState createState() => _BluetoothSearchState();
}

class _BluetoothSearchState extends State<BluetoothSearch> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  String _devicesMsg = "";
  bool _request = false;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _disconnect();
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
      if (devices.isEmpty) {
        setState(() {
          _devicesMsg = "0 Dispositivos Registrados";
        });
      }
    } on PlatformException {
      setState(() {
        _devicesMsg =
            "Ha ocurrido un error. Salga de la pestaña y entre nuevamente.";
      });
    }
    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  Future<void> _connect() async {
    if (_device == null) {
      setState(() {
        _devicesMsg = 'No device selected';
      });
    } else {
      bool a = await bluetooth.isConnected;
      if (!a) {
        try {
          await bluetooth.connect(_device);
        } on Exception catch (error) {
          setState(() {
            _request = false;
          });
          print("Respuetas de Connect");
        }
      }
    }
  }

  Future<void> _disconnect() async {
    final a = await bluetooth.disconnect();
    if (a.toString() == "false") {
      setState(() {
        _devicesMsg = a.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var bodyLoading = new Visibility(
      visible: _request,
      child: Container(
        height: size.height,
        width: size.width,
        color: Color.fromRGBO(0, 0, 0, .6),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: _devicesMsg != ""
          ? Center(
              child: Text(_devicesMsg),
            )
          : _request
              ? bodyLoading
              : ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (c, i) {
                    return ListTile(
                      title: Text(_devices[i].name),
                      subtitle: Text(_devices[i].address),
                      onLongPress: () {
                        setState(() {
                          _device = _devices[i];
                        });
                        savePrinter(context);
                      },
                      onTap: () async {
                        setState(() {
                          _device = _devices[i];
                          print(_device.name);
                          _request = true;
                        });
                        await _connect();
                        await _tesPrint();
                        await _disconnect();
                        setState(() {
                          _request = false;
                        });
                      },
                    );
                  },
                ),
    );
  }
  Future<void> _tesPrint() async{
    bool isConnected = await bluetooth.isConnected;
    if (isConnected) {
      await bluetooth.printNewLine();
      
      await bluetooth.printCustom("Gracias por su compra.", 1, 1);
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
    } else {
        throw Exception('Some arbitrary error');
    }
  }
  void savePrinter(BuildContext context) async {
    await Setting.setPrinterName(_device.name);
    await Setting.setPrinteAddress(_device.address);
    await Setting.setPrinterType(_device.type);
    Navigator.pop(context);
  }
}