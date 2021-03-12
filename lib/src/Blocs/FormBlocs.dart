import 'dart:async';

class FormBloc {
  final _rncController = StreamController<String>.broadcast();
  final _nombreController = StreamController<String>.broadcast();
  final _montoController = StreamController<double>.broadcast();
  final _methodController = StreamController<int>.broadcast();
  //Recuperar data de los controlles
  Stream<String> get rncStream => _rncController.stream;
  Stream<String> get nombreStream => _nombreController.stream;
  Stream<double> get montoStream => _montoController.stream;
  Stream<int>    get methodStream => _methodController.stream;
  //insertar valores al Stream
  Function(String) get changeRnc => _rncController.sink.add;
  Function(String) get changeNombre => _nombreController.sink.add;
  Function(double) get changeMonto => _montoController.sink.add;
  Function(int)    get  changeMethod => _methodController.sink.add;

}
