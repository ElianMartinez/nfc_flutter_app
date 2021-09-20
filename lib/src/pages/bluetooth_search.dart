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
  @override
  void initState() {
    super.initState();
    initPlatformState();
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
      final a = await bluetooth.isConnected;
      if (!a) {
        final error = await bluetooth.connect(_device);
        setState(() {
          _devicesMsg = error.toString();
        });
      }
    }
  }

  Future<void> _disconnect() async {
    final a = await bluetooth.disconnect();
    setState(() {
      _devicesMsg = a.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth Devices'),
        ),
        body: _devicesMsg != ""
            ? Center(
                child: Text(_devicesMsg),
              )
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
                      });
                      print(_device.name);
                      await _connect();
                      await _tesPrint();
                      await _disconnect();
                    },
                  );
                },
              ));
  }

  void savePrinter(BuildContext context) async {
    await Setting.setPrinterName(_device.name);
    await Setting.setPrinteAddress(_device.address);
    await Setting.setPrinterType(_device.type);
    Navigator.pop(context);
  }

  Future<void> _tesPrint() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    bool isConnected = await bluetooth.isConnected;
    if (isConnected) {
      await bluetooth.printCustom("HEADER", 3, 1);
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
      await bluetooth.printLeftRight("LEFT", "RIGHT", 0);
      await bluetooth.printLeftRight("LEFT", "RIGHT", 1);
      await bluetooth.printNewLine();
      await bluetooth.printLeftRight("LEFT", "RIGHT", 2);
      await bluetooth.printCustom("Body left", 1, 0);
      await bluetooth.printCustom("Body right", 0, 2);
      await bluetooth.printNewLine();
      await bluetooth.printCustom("Terimakasih", 2, 1);
      await bluetooth.printNewLine();
      await bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 5);
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
    } else {
      setState(() {
        _devicesMsg = "Error";
      });
    }
  }
}
