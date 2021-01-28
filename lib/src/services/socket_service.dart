import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/global/env.dart';
import 'package:flutter_chat_app/src/services/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => this._socket.emit;

  SocketService();

  void connect() async {
    final token = await AuthService.getToken();

    print('iniciando socket...');
    this._socket = IO.io(
        Env.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({'Authorization': token})
            .build());

    this._socket.onConnect((_) {
      print('socket connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      print('socket disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    this._socket.connect();
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
