class RNC { 
 
  String nombre;

RNC({this.nombre});

factory RNC.fromJson(Map<String, dynamic> json) {
    return RNC(
      nombre: json['data'],
    );
  }
factory RNC.error(valor){
    return RNC (
nombre: valor,
    );
  }
}