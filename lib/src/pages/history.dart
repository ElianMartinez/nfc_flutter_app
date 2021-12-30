import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncf_flutter_app/src/models/Comprobantes_Models.dart';
import 'package:ncf_flutter_app/src/models/DataTikect.dart';
import 'package:ncf_flutter_app/src/pages/print.dart';
import 'package:ncf_flutter_app/src/services/ComprobanteService.dart';

class History_Facture extends StatefulWidget {
  const History_Facture({Key key}) : super(key: key);
  @override
  _History_FactureState createState() => _History_FactureState();
}

class _History_FactureState extends State<History_Facture> {
  ComprobanteServives cs = new ComprobanteServives();
  List<Comprobant> list;
  bool loader = false;

  void getBuscar() async {
    setState(() {
      loader = true;
    });
    Comprobante element = await cs.buscarComprobantes('0', false);
    list = element.data;
    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBuscar();
  }

  // String varl = "RD$";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Historial de Recibos"),
        ),
        body: Stack(children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100.0,
                child: Center(
                    child: Text(
                  'Historial',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900),
                )),
              ),
              Container(
                width: double.infinity,
                height: 35.0,
                color: Color.fromRGBO(145, 145, 145, 0.2),
                child: Center(
                  child: Text(
                    "Recibos Recientes",
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Color.fromRGBO(145, 145, 145, 1)),
                  ),
                ),
              ),
            ],
          ),
          loader
              ? Center(child: CircularProgressIndicator())
              : historyItem(context, list)
        ]),
      ),
    );
  }

  Widget historyItem(BuildContext context, List<Comprobant> dtt) =>
      ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: dtt.length,
          itemBuilder: (BuildContext context, int index) {
            return historialItem(context, dtt[index]);
          });

  Widget historialItem(BuildContext context, Comprobant dtt) {
    DataTikect res = new DataTikect();
    final mp = dtt.idMetodoPago == 2 ? "Efectivo" : "Tarjeta";

    var fechaActual = DateFormat('dd/MM/yyyy KK:mm a').format(dtt.hora);
    res.nombreCliente = dtt.nombreCompania;
    res.nombreEmpresa = dtt.nombreSucursal;
    res.rncCliente = dtt.rnc;
    res.monto = dtt.montoEfectivo;
    res.noFac = dtt.id;
    res.ncf = dtt.ncf;
    res.fecha = fechaActual;
    res.metPago = mp;
    res.rncEmpresa = dtt.rncEmpresa;
    res.direccionSucursal = dtt.direccion;
    res.telSucursal = dtt.telefono;
    res.nombreTipo = 'CREDITO FISCAL';
    res.fechaVence = DateFormat('dd/MM/yyyy').format(dtt.fechaVence);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color.fromRGBO(245, 245, 245, 1),
          border:
              Border.all(width: 0.5, color: Color.fromRGBO(200, 200, 200, 1))),
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RNC: " + dtt.rnc,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          Text(
            "NCF: " + dtt.ncf,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          Text(
            "Método.Pago: " + mp,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          Text(
            dtt.nombreCompania,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          Text("RD" + NumberFormat.simpleCurrency().format(dtt.monto),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
          Text(
            DateFormat('dd/MM/yyyy KK:mm a').format(dtt.hora),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          TextButton(
              child: Row(
                children: [
                  Text(
                    "Print",
                    style: TextStyle(color: Colors.red, fontSize: 18.0),
                  ),
                  Icon(
                    Icons.print_outlined,
                    color: Colors.red,
                  )
                ],
              ),
              onPressed: () => showAlertDialog(context, res)),
        ],
      ),
    );
  }

  Widget showAlertDialog(BuildContext context, DataTikect dtt) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Si"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PrintTicket(
                    dataTikect: dtt,
                  )),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Imprimir recibos"),
      content: Text("Quieres imprimir este recibo? "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
