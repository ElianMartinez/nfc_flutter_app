import 'package:flutter/material.dart';

class Pass extends StatefulWidget {
  Pass({key}) : super(key: key);

  @override
  _PassState createState() => _PassState();
}

class _PassState extends State<Pass> {
  final FocusNode pass = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pass.dispose();
  }

  void Veri(String v) {
    if (v == "09082001") {
      Navigator.pop(context);
      Navigator.of(context).pushNamed('/config');
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(pass);
    return Scaffold(
      appBar: new AppBar(
        title: Text("Privado"),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        child: TextField(
          autocorrect: false,
          keyboardType: TextInputType.number,
          onSubmitted: (v) {
            Veri(v);
          },
          obscureText: true,
          enableSuggestions: false,
          focusNode: pass,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Ingrese el password'),
        ),
      ),
    );
  }
}
