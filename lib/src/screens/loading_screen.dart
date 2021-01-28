import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/screens/login_screen.dart';
import 'package:flutter_chat_app/src/screens/usuarios_screen.dart';
import 'package:flutter_chat_app/src/services/auth_service.dart';
import 'package:flutter_chat_app/src/services/socket_service.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Cargando...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();
    print(autenticado);
    if (autenticado) {
      // Navigator.pushReplacementNamed(context, 'usuarios');
      //EVITAMOS LA ANIMACIÓN DE TRANSICIÓN ENTRE PANTALLAS
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.connect();
      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => UsuariosScreen()));
    } else {
      // Navigator.pushReplacementNamed(context, 'login');
      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => LoginScreen()));
    }
  }
}
