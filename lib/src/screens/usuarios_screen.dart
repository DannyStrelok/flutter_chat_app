import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/models/usuario.dart';
import 'package:flutter_chat_app/src/services/auth_service.dart';
import 'package:flutter_chat_app/src/services/chat_service.dart';
import 'package:flutter_chat_app/src/services/socket_service.dart';
import 'package:flutter_chat_app/src/services/usuarios_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuariosService = new UsuariosService();
  List<Usuario> usuarios = [];

  // final usuarios = [
  //   Usuario(uuid: '1', nombre: 'Daniel', email: 'test@test.com', online: true),
  //   Usuario(uuid: '2', nombre: 'Eva', email: 'test1@test.com', online: true),
  //   Usuario(uuid: '3', nombre: 'Jorge', email: 'test2@test.com', online: false),
  // ];

  @override
  void initState() {
    this._loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          authService.usuario.nombre,
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black54,
          ),
          onPressed: () {
            socketService.disconnect();
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[400],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
            // child: Icon(Icons.check_circle, color: Colors.red,),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[400],
        ),
        child: _listViewUsuarios(),
      ),
    );
  }

  ListTile _userListTile(Usuario usuario) {
    return ListTile(
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioTo = usuario;
        Navigator.pushNamed(context, 'chat');
      },
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2).toUpperCase()),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[400] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  _loadUsers() async {
    // await Future.delayed(Duration(milliseconds: 1000));

    this.usuarios = await this.usuariosService.getUsuarios();
    setState(() {});

    _refreshController.refreshCompleted();
  }
}
