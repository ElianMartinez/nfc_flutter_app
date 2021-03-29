import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class Imprimir {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  DataTikect datatikect;

  Imprimir(DataTikect dataTikect) {
    this.datatikect = dataTikect;
  }

  Future<String> startPrint() async {
    BluetoothDevice n = new BluetoothDevice();
    n.name = await Setting.getPrinterName();
    n.address = await Setting.getPrinteAddress();
    n.type = await Setting.getPrinterType();
    print(n.address);
    PrinterBluetooth printer = new PrinterBluetooth(n);
    _printerManager.selectPrinter(printer);
    PosPrintResult result = await _printerManager.printTicket(await _ticket());
    print(result.msg);
    return result.msg;
  }
  Future<Ticket> _ticket() async {
    final ticket = Ticket(PaperSize.mm58);
    ticket.emptyLines(1);

    ticket.text(
      datatikect.nombreEmpresa,
      styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );

    ticket.row([
      PosColumn(text: "RNC:${datatikect.rncEmpresa}", width: 6),
      PosColumn(text: "Tel:${datatikect.telSucursal}", width: 6),
    ]);
    ticket.text(
      datatikect.direccionSucursal,
      styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );
    ticket.feed(1);
    ticket.row([
      PosColumn(text: 'No:${datatikect.noFac}', width: 6),
      PosColumn(
        text: 'Fecha:${datatikect.fecha}',
        width: 6,
      ),
    ]);

    ticket.emptyLines(1);

    ticket.text(
      datatikect.nombreTipo,
      styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 1,
    );
    ticket.text(
      'NCF: ${datatikect.ncf}',
      styles: PosStyles(
          bold: true,
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );
    ticket.text(
      'RNC: ${datatikect.rncCliente}',
      styles: PosStyles(
          bold: true,
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );
    ticket.text(
      datatikect.nombreCliente,
      styles: PosStyles(
          bold: true,
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1),
      linesAfter: 0,
    );
    ticket.row([
      PosColumn(text: 'Met.Pago: ${datatikect.metPago}', width: 12),
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
    ticket.text('Total: ${datatikect.monto}',
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
}
