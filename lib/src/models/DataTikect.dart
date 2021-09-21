class DataTikect {
  String _nombreTipo;
  double _monto;
  String _metPago;
  String _nombreCliente;
  String _rncCliente;
  String _ncf;
  String _fecha;
  int _noFac;
  String _direccionSucursal;
  String _telSucursal;
  String _rncEmpresa;
  String _nombreEmpresa;
  DataTikect();
  /* Begin Json methods*/
  Map<String, dynamic> toJson() => {
        "nombreTipo": _nombreTipo,
        "monto": _monto,
        "metPago": _metPago,
        "nombreCliente": _nombreCliente,
        "rncCliente": _rncCliente,
        "ncf": _ncf,
        "fecha": _fecha,
        "noFac": _noFac,
        "direccionSucursal": _direccionSucursal,
        "telSucursal": _telSucursal,
        "rncEmpresa": _rncEmpresa,
        "nombreEmpresa": _nombreEmpresa,
      };

  DataTikect.fromJson(Map<String, dynamic> json)
      : _nombreTipo = json["nombreTipo"],
        _monto = json["monto"],
        _metPago = json["metPago"],
        _nombreCliente = json["nombreCliente"],
        _rncCliente = json["rncCliente"],
        _ncf = json["ncf"],
        _fecha = json["fecha"],
        _noFac = json["noFac"],
        _direccionSucursal = json["direccionSucursal"],
        _telSucursal = json["telSucursal"],
        _rncEmpresa = json["rncEmpresa"],
        _nombreEmpresa = json["nombreEmpresa"];

  /* End Json methods*/

  /* Begin Getters and Setter */

  String get nombreTipo => _nombreTipo;

  set nombreTipo(String nombreTipo) {
    _nombreTipo = nombreTipo;
  }

  String get nombreEmpresa => _nombreEmpresa;

  set nombreEmpresa(String nombreEmpresa) {
    _nombreEmpresa = nombreEmpresa;
  }

  String get rncEmpresa => _rncEmpresa;

  set rncEmpresa(String rncEmpresa) {
    _rncEmpresa = rncEmpresa;
  }

  String get telSucursal => _telSucursal;

  set telSucursal(String telSucursal) {
    _telSucursal = telSucursal;
  }

  String get direccionSucursal => _direccionSucursal;
  set direccionSucursal(String direccionSucursal) {
    _direccionSucursal = direccionSucursal;
  }

  int get noFac => _noFac;
  set noFac(int noFac) {
    _noFac = noFac;
  }

  String get fecha => _fecha;
  set fecha(String fecha) {
    _fecha = fecha;
  }

  String get ncf => _ncf;

  set ncf(String ncf) {
    _ncf = ncf;
  }

  String get rncCliente => _rncCliente;

  set rncCliente(String rncCliente) {
    _rncCliente = rncCliente;
  }

  String get nombreCliente => _nombreCliente;

  set nombreCliente(String nombreCliente) {
    _nombreCliente = nombreCliente;
  }

  String get metPago => _metPago;

  set metPago(String metPago) {
    _metPago = metPago;
  }

  double get monto => _monto;

  set monto(double monto) {
    _monto = monto;
  }
}
/* End Getters and Setter */
