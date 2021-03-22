
class Sucursales {
  int iDSUCURSAL;
  String nOMBRE;
  String dIRECCION;
  String tELEFONO;
  int iDCOMPANY;
  int uSO;

  Sucursales(
      {this.iDSUCURSAL,
      this.nOMBRE,
      this.dIRECCION,
      this.tELEFONO,
      this.iDCOMPANY,
      this.uSO});

  void fromJson(Map<String, dynamic> json) {
    iDSUCURSAL = json['ID_SUCURSAL'];
    nOMBRE = json['NOMBRE'];
    dIRECCION = json['DIRECCION'];
    tELEFONO = json['TELEFONO'];
    iDCOMPANY = json['ID_COMPANY'];
    uSO = json['USO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_SUCURSAL'] = this.iDSUCURSAL;
    data['NOMBRE'] = this.nOMBRE;
    data['DIRECCION'] = this.dIRECCION;
    data['TELEFONO'] = this.tELEFONO;
    data['ID_COMPANY'] = this.iDCOMPANY;
    data['USO'] = this.uSO;
    return data;
  }
}