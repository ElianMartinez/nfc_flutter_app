import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:intl/intl.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';

class PrintC {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  String _devicesMsg ="";
  BluetoothDevice _device;
  PrintC();

  Future<void> _connect() async {
    if (_device == null) {
      this._devicesMsg = 'No device selected';
    } else {
      bool a = await bluetooth.isConnected;
      if (!a) {
        try {
          await bluetooth.connect(_device);
        } on Exception catch (_) {
          throw Exception('Some arbitrary error');

        }
      }
    }
  }

  Future<void> _disconnect() async {
    final a = await bluetooth.disconnect();
    if (a.toString() == "false") {
      this._devicesMsg = a.toString();
    }
  }

  Future<String> printT(DataTikect tik) async {
    final device = new BluetoothDevice(
        await Setting.getPrinterName(), await Setting.getPrinteAddress());
    _device = device;
    await _connect();
   String res = await _Print(tik);
    await _disconnect();
    return res;
  }

  Future<String> _Print(DataTikect ticket) async {
    String res = "";
    bool isConnected = await bluetooth.isConnected;
    if (isConnected) {
      await bluetooth.printNewLine();
      await bluetooth.printCustom(ticket.nombreEmpresa, 1, 1);
      await bluetooth.printLeftRight(
          "RNC:${ticket.rncEmpresa}", "Tel:${ticket.telSucursal}", 0);
      await bluetooth.printCustom(ticket.direccionSucursal, 0, 1);
      await bluetooth.printNewLine();
      await bluetooth.printLeftRight(
          "No:${ticket.noFac}", "Fecha: ${ticket.fecha}", 0);
      await bluetooth.printNewLine();
      await bluetooth.printCustom("CREDITO FISCAL", 1, 1);
      await bluetooth.printLeftRight(
          "NCF: ${ticket.ncf}", "RNC: ${ticket.rncCliente}", 1);
      await bluetooth.write("Nombre Empresa: ");
      await bluetooth.printCustom(ticket.nombreCliente, 0, 0);
      await bluetooth.printCustom("Metodo.Pag: ${ticket.metPago}", 0, 0);
      await bluetooth.write("__________________________________________");
      await bluetooth.printNewLine();
      await bluetooth.printCustom(
          "RD" + NumberFormat.simpleCurrency().format(ticket.monto), 2, 1);
      await bluetooth.printNewLine();
      await bluetooth.printCustom("Gracias por su compra.", 1, 1);
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
      await bluetooth.printNewLine();
    } else {
        throw Exception('Some arbitrary error');
    }

    
  }
}
