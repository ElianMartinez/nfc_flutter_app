import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:ncf_flutter_app/src/models/Imprimir.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class BluetoothSearch extends StatefulWidget {

  @override
  _BluetoothSearchState createState() => _BluetoothSearchState();
}

class _BluetoothSearchState extends State<BluetoothSearch> {
  @override
  void initState() {}

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Center(
        child: Text("Hola"),
      ),
    );
  }

  void savePrinter(BuildContext context) async {
    // await Setting.setPrinterName(_device.name);
    // await Setting.setPrinteAddress(_device.address);
    // await Setting.setPrinterType(_device.type);
    Navigator.pop(context);
  }
}
