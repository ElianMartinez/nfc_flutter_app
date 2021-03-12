import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ncf_flutter_app/src/widgets/drawer.dart';

class FormNcf extends StatefulWidget {
  @override
  _FormNcfState createState() => _FormNcfState();
}

class _FormNcfState extends State<FormNcf> {
  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'NCF',
        style: TextStyle(fontSize: 30.0),
      )),
      drawer: drawerW(),
      body: Container(
        padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
          child: _formulario(),
        ),
      ),
    );
  }
}

Widget _formulario() {
  return Column(children: [
    TextFormField(
        autofocus: true,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.search,
            size: 50.0,
          ),
          hintText: 'Ingrese el RNC o Cédula',
          labelText: 'RNC - Cédula *',
          
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11)
        ],
        style: TextStyle(
          fontSize: 40.0,
        ),
        onChanged: (text) {
          if (text.length != 9 || text.length != 11) {


          }
        }),
  ]);
}
