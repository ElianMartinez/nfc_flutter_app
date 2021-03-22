import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncf_flutter_app/src/services/sucursalesServices.dart';
import 'package:ncf_flutter_app/src/setting/settings.dart';
import 'package:ncf_flutter_app/src/widgets/drawer.dart';

class ConfigW extends StatefulWidget {
  ConfigW({Key key}) : super(key: key);
  @override
  _ConfigWState createState() => _ConfigWState();
}

class _ConfigWState extends State<ConfigW> {
  TextEditingController controller = TextEditingController();
  TextEditingController idC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  String errorID = null;
  bool _request = false;
  String errorIp = null;
  SucursalesServices services = new SucursalesServices();
  void _probar_connect() async {
    if (controller.text != '' && controller.text.length >= 12) {
      setState(() {
        errorIp = null;
        _request = true;
      });
      bool data = await services.getSucursales(controller.text);
      setState(() {
        _request = false;
      });
      if (data == false ) {
        setState(() {
          errorIp = "Esa direccion no corresponde";
        _request = false;
        });
      } else {
        setState(() {
          errorIp = null;
        });
      }
    } else {
      setState(() {
        errorIp = "Debe ingresar la ip correcta";
      });
    }
  }

  void _inicial() async {
    controller.text = await Setting.getHost();
    nameC.text = await Setting.getNameSucursal();
    idC.text = await Setting.getIdSucursal();
  }

  void _guardar_dato() async {
    String id_f = await Setting.getIdSucursal();
    if (id_f != idC.text) {
      String name = await services.getSucursal(int.parse(idC.text));
      if (name != "false" && name != "error") {
        nameC.text = name != "ocupado" ? name : "";
        setState(() { 
          errorID = null;
        });
      } else if (name == "false") {
        setState(() {
          errorID = "Esa sucursal ya está en uso.";
        });
      } else {
        setState(() {
          errorID = "Ocurrio un error. Intente de nuevo.";
        });
      }
    }
  }

  @override
  void initState() {
    _inicial();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: drawerW(),
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'SERVIDOR',
                        errorText: errorIp,
                        hintText: 'Ingrese la ip del servidor',
                        icon: Icon(Icons.network_check_outlined),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.singleLineFormatter,
                        LengthLimitingTextInputFormatter(25)
                      ],
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.blue,
                    child: FlatButton(
                      child: Text('Probar',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        _probar_connect();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextField(
                      controller: idC,
                      decoration: InputDecoration(
                        labelText: 'Sucursal',
                        hintText: 'ID de la sucursal',
                        errorText: errorID,
                        icon: Icon(Icons.business),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next),
                  TextField(
                      controller: nameC,
                      decoration: InputDecoration(
                        labelText: 'Nombre Sucursal',
                        enabled: false,
                        icon: Icon(Icons.business),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    color: Colors.blue,
                    child: FlatButton(
                      child: Text('Guardar',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        _guardar_dato();
                      },
                    ),
                  ),
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
      ),
    );
  }
}
