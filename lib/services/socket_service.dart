import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus{
  online, 
  offline,
  connecting
}

class SocketServices with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  Map<String,dynamic> _payload = Map();
  IO.Socket? socket;

  SocketServices(){
    _initConfig();
  }

  get serverStatus => _serverStatus;
  get serverPayload => _payload;

  _initConfig() {
    socket = IO.io('http://localhost:3000/', 
      OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM // optional
        .build());

    socket?.onConnect((_) {
      _serverStatus = ServerStatus.online;
      print('connect');
      notifyListeners();
    });
    socket?.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      print('disconnect');
      notifyListeners();
    });

    socket?.on('nuevo-mensaje', (payload) {
      print('Message from server: ${payload}');
      _payload = {'user': payload['user'], 'mensaje': payload['mensaje']};
      notifyListeners();
    });

  }

}