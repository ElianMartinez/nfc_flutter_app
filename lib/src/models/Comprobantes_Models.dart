// To parse this JSON data, do
//
//     final comprobante = comprobanteFromJson(jsonString);

import 'dart:convert';

Comprobante comprobanteFromJson(String str) => Comprobante.fromJson(json.decode(str));

String comprobanteToJson(Comprobante data) => json.encode(data.toJson());

class Comprobante {
    Comprobante({
        this.res,
        this.data,
    });

    String res;
    List<Comprobant> data;

    factory Comprobante.fromJson(Map<String, dynamic> json) => Comprobante(
        res: json["res"],
        data: List<Comprobant>.from(json["data"].map((x) => Comprobant.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "res": res,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Comprobant {
    Comprobant({
        this.nombreEmpresa,
        this.rncEmpresa,
        this.direccion,
        this.telefono,
        this.id,
        this.rnc,
        this.nombreCompania,
        this.nfcTip,
        this.ncf,
        this.hora,
        this.fecDoc,
        this.monto,
        this.numDoc,
        this.idSucursal,
        this.idMetodoPago,
        this.tipo,
        this.montoEfectivo,
        this.montoTarjeta,
        this.montoCredito,
        this.cta,
        this.impuesto,
        this.descuento,
        this.ncfM,
        this.tipoIngreso,
        this.ventaCredito,
        this.ventaTarjeta,
        this.ventaEfectivo,
        this.otros,
        this.fechaVence,
        this.nombreSucursal,
    });

    String nombreEmpresa;
    String rncEmpresa;
    String direccion;
    String telefono;
    int id;
    String rnc;
    String nombreCompania;
    int nfcTip;
    String ncf;
    DateTime hora;
    DateTime fecDoc;
    int monto;
    int numDoc;
    int idSucursal;
    int idMetodoPago;
    int tipo;
    double montoEfectivo;
    double montoTarjeta;
    dynamic montoCredito;
    dynamic cta;
    dynamic impuesto;
    dynamic descuento;
    dynamic ncfM;
    int tipoIngreso;
    double ventaCredito;
    double ventaTarjeta;
    double ventaEfectivo;
    dynamic otros;
    DateTime fechaVence;
    String nombreSucursal;

    factory Comprobant.fromJson(Map<String, dynamic> json) => Comprobant(
        nombreEmpresa: json["NOMBRE_EMPRESA"],
        rncEmpresa: json["RNC_EMPRESA"],
        direccion: json["DIRECCION"],
        telefono: json["TELEFONO"],
        id: json["ID"],
        rnc: json["RNC"],
        nombreCompania: json["NOMBRE_COMPANIA"],
        nfcTip: json["NFC_TIP"],
        ncf: json["NCF"],
        hora: DateTime.parse(json["HORA"]),
        fecDoc: DateTime.parse(json["FEC_DOC"]),
        monto: json["MONTO"],
        numDoc: json["NUM_DOC"],
        idSucursal: json["ID_SUCURSAL"],
        idMetodoPago: json["ID_METODO_PAGO"],
        tipo: json["TIPO"],
        montoEfectivo: json["MONTO_EFECTIVO"].toDouble(),
        montoTarjeta: json["MONTO_TARJETA"].toDouble(),
        montoCredito: json["MONTO_CREDITO"],
        cta: json["CTA"],
        impuesto: json["IMPUESTO"],
        descuento: json["DESCUENTO"],
        ncfM: json["NCF_M"],
        tipoIngreso: json["TIPO_INGRESO"],
        ventaCredito: json["VENTA_CREDITO"].toDouble(),
        ventaTarjeta: json["VENTA_TARJETA"].toDouble(),
        ventaEfectivo: json["VENTA_EFECTIVO"].toDouble(),
        otros: json["OTROS"],
        fechaVence: DateTime.parse(json["FECHA_VENCE"]),
        nombreSucursal: json["NOMBRE_SUCURSAL"],
    );

    Map<String, dynamic> toJson() => {
        "NOMBRE_EMPRESA": nombreEmpresa,
        "RNC_EMPRESA": rncEmpresa,
        "DIRECCION": direccion,
        "TELEFONO": telefono,
        "ID": id,
        "RNC": rnc,
        "NOMBRE_COMPANIA": nombreCompania,
        "NFC_TIP": nfcTip,
        "NCF": ncf,
        "HORA": hora.toIso8601String(),
        "FEC_DOC": fecDoc.toIso8601String(),
        "MONTO": monto,
        "NUM_DOC": numDoc,
        "ID_SUCURSAL": idSucursal,
        "ID_METODO_PAGO": idMetodoPago,
        "TIPO": tipo,
        "MONTO_EFECTIVO": montoEfectivo,
        "MONTO_TARJETA": montoTarjeta,
        "MONTO_CREDITO": montoCredito,
        "CTA": cta,
        "IMPUESTO": impuesto,
        "DESCUENTO": descuento,
        "NCF_M": ncfM,
        "TIPO_INGRESO": tipoIngreso,
        "VENTA_CREDITO": ventaCredito,
        "VENTA_TARJETA": ventaTarjeta,
        "VENTA_EFECTIVO": ventaEfectivo,
        "OTROS": otros,
        "FECHA_VENCE": fechaVence.toIso8601String(),
        "NOMBRE_SUCURSAL": nombreSucursal,
    };
}