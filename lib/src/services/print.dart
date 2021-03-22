import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:io' show Platform;
import 'package:image/image.dart';

class Print extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  Print(this.data);
  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  //PRUEBA
  BluetoothDevice bluetoothDevice = new BluetoothDevice();
  PrinterBluetooth printerBluetooth;
  void initState() {
    // if (Platform.isAndroid) {
    //   bluetoothManager.state.listen((val) {
    //     print('state = $val');
    //     if (!mounted) return;
    //     if (val == 12) {
    //       print('on');
    //       initPrinter();
    //     } else if (val == 10) {
    //       print('off');
    //       setState(() => _devicesMsg = 'Bluetooth Disconnect!');
    //     }
    //   });
    // } else {
    //   initPrinter();
    // }

    bluetoothDevice.address = "66:22:AF:54:1F:18";
    bluetoothDevice.name = "LARASOFTS-N1";
    bluetoothDevice.type = 2;

    printerBluetooth = new PrinterBluetooth(bluetoothDevice);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Print')),
      body: Center(
        child: RaisedButton(
          child: Text('Imprimr'),
          onPressed: () => {
            _startPrint(printerBluetooth)
          },
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Print'),
  //     ),
  //     body: _devices.isEmpty
  //         ? Center(child: Text(_devicesMsg ?? ''))
  //         : ListView.builder(
  //             itemCount: _devices.length,
  //             itemBuilder: (c, i) {
  //               if (_devices[i].address == "66:22:AF:54:1F:18") {
  //                 return ListTile(
  //                   leading: Icon(Icons.print),
  //                   title: Text(
  //                       _devices[i].name + " : " + _devices[i].type.toString()),
  //                   subtitle: Text(_devices[i].address),
  //                   onTap: () {
  //                     _startPrint(_devices[i]);
  //                   },
  //                 );
  //               }
  //             },
  //           ),
  //   );
  // }

  // void initPrinter() {
  //   _printerManager.startScan(Duration(seconds: 1));
  //   _printerManager.scanResults.listen((val) {
  //     if (!mounted) return;
  //     setState(() => _devices = val);
  //     if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
  //   });
  // }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result =
        await _printerManager.printTicket(await _ticket(PaperSize.mm58));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
    ticket.emptyLines(1);

    ticket.text(
      'NOMBRE DE LA EMPRESA',
      styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );

    ticket.row([
      PosColumn(text: "RNC:123456789", width: 6),
      PosColumn(text: "Tel:809-689-8978", width: 6),
    ]);
    ticket.text(
      'Direccion de la sucursal aqui va',
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );
    ticket.feed(1);
    ticket.row([
      PosColumn(text: 'No:056489', width: 6),
      PosColumn(
        text: 'Fecha:03/02/2021',
        width: 6,
      ),
    ]);

    ticket.text(
      'DATOS DEL CLIENTE',
      styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 1,
    );
    ticket.text(
      'NCF: B0100000008',
      styles: PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );
    ticket.text(
      'RNC: 101070803.',
      styles: PosStyles(
          bold: true,
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );
    ticket.text(
      'JUANITO MARCLO LORA SRL.',
      styles: PosStyles(
          bold: true,
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );
    ticket.row([
      PosColumn(text: 'Met.Pago: Efectivo', width: 12),
    ]);
    ticket.text(
      '________________________________',
      styles: PosStyles(
          bold: true,
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );

    ticket.text('Total: 2,800,989,698.00',
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size1,
        ));
    ticket.feed(1);
    ticket.text('Gracias',
        styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.cut();
    return ticket;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }
}
