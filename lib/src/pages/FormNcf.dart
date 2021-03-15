import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ncf_flutter_app/src/models/rncClass.dart';
import 'package:ncf_flutter_app/src/provider/rncProvider.dart';
import 'package:ncf_flutter_app/src/widgets/drawer.dart';

class FormNcf extends StatefulWidget {
  @override
  _FormNcfState createState() => _FormNcfState();
}

class _FormNcfState extends State<FormNcf> {
  TextEditingController rncC = TextEditingController();
  TextEditingController nombreC = TextEditingController();
  String rncError = "";
  List<MPay> _mpay = [];
  @override
  Widget build(BuildContext context) {
    _mpay.add(new MPay("Tarjeta", Icons.card_membership, false));
    _mpay.add(new MPay("Efectivo", Icons.money, false));
    final size = MediaQuery.of(context).size;
    RNC dataRNC;
    return Scaffold(
        appBar: AppBar(
            title: Text(
          'NCF FORMULARIO',
          style: TextStyle(fontSize: 30.0),
        )),
        drawer: drawerW(),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                        controller: rncC,
                        autofocus: true,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.search,
                              size: 50.0,
                            ),
                            errorText: rncError != "" ? rncError : null,
                            hintText: 'Ingrese el RNC o Cédula',
                            labelText: 'RNC - Cédula *',
                            errorStyle: TextStyle(fontSize: 25.0)),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11)
                        ],
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                        onChanged: (valor) {
                          if (valor.length == 9 || valor.length == 11) {
                            setState(() {
                              this.rncError = "";
                            });
                            print(rncError);
                          } else {
                            setState(() {
                              this.rncError = "Debe tener 9 u 11 caracteres";
                            });
                          }
                          print(rncError);
                        },
                        onFieldSubmitted: (v) async {
                          if (v != '' && v.length == 9 || v.length == 11) {
                            dataRNC = await fetchRNC(int.parse(v));
                            if (dataRNC.nombre != 'none') {
                              nombreC.text = dataRNC.nombre;
                            } else {}
                          } else {
                            return null;
                          }

                          //Verificar el nombre Stream aqui del fetch
                        }),
                    SizedBox(
                      height: 30.0,
                    ),
                    _inputNombre(nombreC),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      RaisedButton(
                          onPressed: () {
                            setState(() {
                              _mpay[1].isSelected = false;
                              _mpay[0].isSelected = true;
                            });
                          },
                          color: _mpay[0].isSelected
                              ? Color(0xFF3B4257)
                              : Colors.white,
                          child: Container(
                            height: 130,
                            width: 130,
                            alignment: Alignment.center,
                            margin: new EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  _mpay[0].icon,
                                  color: _mpay[0].isSelected
                                      ? Colors.white
                                      : Colors.grey,
                                  size: 60,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _mpay[0].name,
                                  style: TextStyle(
                                      color: _mpay[0].isSelected
                                          ? Colors.white
                                          : Colors.grey),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        width: 50.0,
                      ),
                      RaisedButton(
                          onPressed: () {
                            setState(() {
                              _mpay[1].isSelected = true;
                              _mpay[0].isSelected = false;
                            });
                          },
                          color: _mpay[1].isSelected
                              ? Color(0xFF3B4257)
                              : Colors.white,
                          child: Container(
                            height: 130,
                            width: 130,
                            alignment: Alignment.center,
                            margin: new EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  _mpay[1].icon,
                                  color: _mpay[1].isSelected
                                      ? Colors.white
                                      : Colors.grey,
                                  size: 60,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _mpay[1].name,
                                  style: TextStyle(
                                      color: _mpay[1].isSelected
                                          ? Colors.white
                                          : Colors.grey),
                                )
                              ],
                            ),
                          )),
                    ]),
                    _inputMonto()
                  ],
                ),
              ),
            ),
            Visibility(
              visible: true,
                child: Container(
                height: size.height,
                width: size.width,
                color:Color.fromRGBO(0, 0, 0, 0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children : [
                      CircularProgressIndicator(strokeWidth: 10.0,),
                      SizedBox(height: 10.0),
                      Text('Por favor espere....', style: TextStyle(fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
              ),
            ),
          ],
        ));
  }
}

Widget _inputNombre(nC) {
  return TextField(
    autofocus: true,
    decoration: InputDecoration(
      icon: Icon(
        Icons.business,
        size: 50.0,
      ),
      labelText: 'Nombre',
    ),
    textInputAction: TextInputAction.next,
    style: TextStyle(
      fontSize: 40.0,
    ),
    readOnly: true,
    controller: nC,
    maxLines: null,
  );
}

Widget _inputMonto() {
  return TextField(
    autofocus: true,
    decoration: InputDecoration(
        icon: Icon(
          Icons.search,
          size: 50.0,
        ),
        hintText: 'Ingrese el Monto',
        labelText: 'Monto *',
        // errorText: snapshot.error,
        errorStyle: TextStyle(fontSize: 25.0)),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(11)
    ],
    style: TextStyle(
      fontSize: 40.0,
    ),
  );
}

class MPay {
  String name;
  IconData icon;
  bool isSelected;

  MPay(this.name, this.icon, this.isSelected);
}
