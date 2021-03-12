import 'package:flutter/material.dart';
import 'package:ncf_flutter_app/src/Blocs/FormBlocs.dart';

class Provider extends InheritedWidget{
   
   final formBloc = FormBloc();

  Provider({Key key, Widget child})
  : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static FormBloc of (BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider ).formBloc;
  }
}