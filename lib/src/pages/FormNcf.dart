import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncf_flutter_app/src/services/rncService.dart';
import 'package:ncf_flutter_app/src/widgets/drawer.dart';

class FormNcf extends StatefulWidget {
  @override
  _FormNcfState createState() => _FormNcfState();
}

class _FormNcfState extends State<FormNcf> {
  // Importaciones de servicios
  final RncService serviceRNC = new RncService();

  // Controladores de los inputs
  TextEditingController rncC = TextEditingController();
  TextEditingController nombreC = TextEditingController();
  TextEditingController montoC = TextEditingController();
  //Focuses
  final FocusNode rncFocusNode = FocusNode();
  final FocusNode montoFocusNode = FocusNode();
  bool validate = false;

  //Variables globales
  bool _request = false;
  String rncError = "";
  List<MPay> _mpay = [];
  //variables que contienen info valiosa
  int _rnc = 0;
  int _methodPay = 0;
  double _monto = 0.0;

  @override
  void dispose() {
    rncFocusNode.dispose();
    montoFocusNode.dispose();
    super.dispose();
  }
//Metodos funcionamiento interno

 
   
  
  void _verificar(String valor) {
    setState(() {
      _monto = double.parse(valor);
    });
    if( _rnc != 0 && _methodPay != 0 && _monto != 0 ){
        setState(() {
          validate = true;
        });
    }else{
      setState(() {
          validate = true;
        });
    }
  }

  Future<void> _getRNC(String rnc) async {
    if (rnc.length == 9 || rnc.length == 11) {
      nombreC.text = '';
      setState(() {
        _request = true;
      });
      String resp = await serviceRNC.getRNC(int.parse(rnc));
      if (resp != null && resp != 'void') {
        rncError = '';
        setState(() {
          _request = false;
          _rnc = int.parse(rnc);
        });

        nombreC.text = resp;
      } else if (resp == 'void') {
        setState(() {
          rncError = 'Ese RNC o Cédula no está registrado';
          FocusScope.of(context).requestFocus(rncFocusNode);
          _request = false;
          _methodPay = 0;
          _rnc = 0;
          _mpay[0].isSelected = false;
          _mpay[1].isSelected = false;
          _monto = 0.0;
          montoC.text = '';
        });
      } else {
        setState(() {
          _request = false;
          rncError = "Error del servidor no encontrado";
          FocusScope.of(context).requestFocus(rncFocusNode);
          _methodPay = 0;
          _rnc = 0;
          _mpay[0].isSelected = false;
          _mpay[1].isSelected = false;
          _monto = 0.0;
          montoC.text = '';
        });
      }
    } else {
      setState(() {
        _methodPay = 0;
        _rnc = 0;
        _mpay[0].isSelected = false;
        _mpay[1].isSelected = false;
        _monto = 0.0;
        montoC.text = '';
      });
      FocusScope.of(context).requestFocus(rncFocusNode);
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
                          fontSize: 25.0,
                        ),
                        onChanged: (valor) {
                          nombreC.text = "";
                          setState(() {
                            _methodPay = 0;
                            _rnc = 0;
                            _mpay[0].isSelected = false;
                            _mpay[1].isSelected = false;
                            _monto = 0.0;
                            montoC.text = '';
                          });
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
                          await _getRNC(v);
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
                          onPressed: _rnc > 0
                              ? () {
                                  setState(() {
                                    _mpay[1].isSelected = false;
                                    _mpay[0].isSelected = true;
                                    _methodPay = 1;
                                    FocusScope.of(context)
                                        .requestFocus(montoFocusNode);
                                  });
                                }
                              : null,
                          color: _mpay[0].isSelected
                              ? Color(0xFF3B4257)
                              : Colors.white,
                          child: Container(
                            height: size.width < 475 ? size.width * 0.25 : 130,
                            width: size.width < 475 ? size.width * 0.20 : 130,
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
                          onPressed: _rnc > 0
                              ? () {
                                  setState(() {
                                    _mpay[1].isSelected = true;
                                    _mpay[0].isSelected = false;
                                    _methodPay = 2;
                                  });
                                  FocusScope.of(context)
                                      .requestFocus(montoFocusNode);
                                }
                              : null,
                          color: _mpay[1].isSelected
                              ? Color(0xFF3B4257)
                              : Colors.white,
                          child: Container(
                            height: size.width < 475 ? size.width * 0.25 : 130,
                            width: size.width < 475 ? size.width * 0.20 : 130,
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
                    _inputMonto(_verificar, montoFocusNode, montoC, _methodPay),
                    SizedBox(height: 50.0,),
                    Center(
                      child: Container(
                        width: 200.0,
                        height: 50.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),
                        shape: BoxShape.rectangle,
                        color: Colors.blue,
                        boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4,-4),
                              blurRadius : 5,
                              spreadRadius: 2
                            ),
                            BoxShadow(
                              color: Colors.grey.shade300,
                              offset: Offset(4,4),
                              blurRadius: 5,
                              spreadRadius: 1
                            )

                        ],
                        ),
                        child: FlatButton (
                          onLongPress: validate ? ()=>{ } : null ,
                          child: Text('ENVIAR', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),),

                        ),
                      )
                    )
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
    enabled: false,
    textInputAction: TextInputAction.next,
    style: TextStyle(
      fontSize: 25.0,
    ),
    readOnly: true,
    controller: nC,
    maxLines: null,
  );
}

Widget _inputMonto(
    Function func, FocusNode fn, TextEditingController controller, int mtp) {
  return TextField(
    focusNode: fn,
    controller: controller,
    autofocus: true,
    decoration: InputDecoration(
        icon: Icon(
          Icons.monetization_on_sharp,
          size: 50.0,
        ),
        enabled: mtp != 0 ? true : false,
        hintText: 'Ingrese el Monto',
        labelText: 'Monto *',
        // errorText: snapshot.error,
        errorStyle: TextStyle(fontSize: 25.0)),
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(16)
    ],
    style: TextStyle(
      fontSize: 25.0,
    ),
    onChanged: (v) => {func(v)},
  );
}

class MPay {
  String name;
  IconData icon;
  bool isSelected;

  MPay(this.name, this.icon, this.isSelected);
}
