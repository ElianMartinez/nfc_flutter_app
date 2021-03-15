class Setting {
  static String host = 'localhost';
 static String port = '8999';
 

 static String GetHost() {
    return host;
  }

 static String GetPort(){
    return port;
  }

  SetHost (String _host){
    host = _host;
  }
  SetPort (String _port){
    port = _port;
  }

} 