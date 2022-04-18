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
  late IO.Socket _socket;

  SocketServices(){
    _initConfig();
  }

  get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  Function get emit => _socket.emit;

  _initConfig() {
    _socket = IO.io('http://192.168.1.51:3000/', 
      OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM // optional
        .build());

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      print('connect');
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      print('disconnect');
      notifyListeners();
    });

  }

}