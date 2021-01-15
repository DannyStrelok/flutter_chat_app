import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/screens/chat_screen.dart';
import 'package:flutter_chat_app/src/screens/loading_screen.dart';
import 'package:flutter_chat_app/src/screens/login_screen.dart';
import 'package:flutter_chat_app/src/screens/registro_screen.dart';
import 'package:flutter_chat_app/src/screens/usuarios_screen.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsuariosScreen(),
  'chat': (_) => ChatScreen(),
  'login': (_) => LoginScreen(),
  'registro': (_) => RegistroScreen(),
  'loading': (_) => LoadingScreen(),
};