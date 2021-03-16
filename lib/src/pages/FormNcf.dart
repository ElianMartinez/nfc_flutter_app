import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncf_flutter_app/src/services/rncService.dart';
import 'package:ncf_flutter_app/src/widgets/drawer.dart';

class FormNcf extends StatefulWidget {
  @override
  _FormNcfState createState() => _FormNcfState();
}

class _FormNcfState extends State<FormNcf> {
  final FocusNode rncFocusNode = FocusNode();
  TextEditingController rncC = TextEditingController();
  TextEditingController nombreC = TextEditingController();
  bool _request = false;
  String rncError = "";
  List<MPay> _mpay = [];
  final RncService serviceRNC = new RncService();
  @override
  void dispose() {
    rncFocusNode.dispose();
    super.dispose();
  }

  Future<void> getRNC(String rnc) async {
    if (rnc.length == 9 || rnc.length == 11) {
      setState(() {
        _request = true;
      });
      String resp = await serviceRNC.getRNC(int.parse(rnc));
      if (resp != null && resp != 'void') {
        rncError = '';
        setState(() {
          _request = false;
        });
        nombreC.text = resp;
      } else if (resp == 'void') {
        setState(() {
          rncError = 'Ese RNC o Cédula no está registrado';
          FocusScope.of(context).requestFocus(rncFocusNode);
          _request = false;
        });
      } else {
        setState(() {
          _request = false;
          rncError = "Error del servidor no encontrado";
          FocusScope.of(context).requestFocus(rncFocusNode);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _mpay.add(new MPay("Tarjeta", Icons.card_membership, false));
    _mpay.add(new MPay("Efectivo", Icons.money, false));
    final size = MediaQuery.of(context).size;

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
                        focusNode: rncFocusNode,
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
                          } else {
                            setState(() {
                              this.rncError = "Debe tener 9 u 11 caracteres";
                            });
                          }
                        },
                        onFieldSubmitted: (v) async {
                          
                          await getRNC(v);
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
