import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_app/src/models/mensajes_response.dart';
import 'package:flutter_chat_app/src/services/auth_service.dart';
import 'package:flutter_chat_app/src/services/chat_service.dart';
import 'package:flutter_chat_app/src/services/socket_service.dart';
import 'package:flutter_chat_app/src/widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textEditingController =
      new TextEditingController();
  final FocusNode _focusNode = new FocusNode();
  bool _isTyping = false;
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  final List<ChatMessage> _chatMessages = [];

  @override
  void initState() {
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', this._messageListener);

    _cargarHistorial(this.chatService.usuarioTo.uuid);

    super.initState();
  }

  void _messageListener(dynamic data) {
    ChatMessage message = new ChatMessage(
        text: data['message'],
        uuid: data['from'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _chatMessages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioTo = this.chatService.usuarioTo;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                usuarioTo.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              usuarioTo.nombre,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _chatMessages.length,
              itemBuilder: (_, i) => _chatMessages[i],
              reverse: true,
            )),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      height: 50,
      child: Row(
        children: [
          Flexible(
              fit: FlexFit.tight,
              child: TextField(
                controller: _textEditingController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  if (text.trim().length > 0) {
                    if (!_isTyping) {
                      setState(() {
                        _isTyping = true;
                      });
                    }
                  } else {
                    if (_isTyping) {
                      setState(() {
                        _isTyping = false;
                      });
                    }
                  }
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Escribe un mensaje',
                ),
                focusNode: _focusNode,
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _isTyping
                        ? () =>
                            _handleSubmit(_textEditingController.text.trim())
                        : null,
                  )
                : IconTheme(
                    data: IconThemeData(color: Colors.blue[400]),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send),
                      onPressed: _isTyping
                          ? () =>
                              _handleSubmit(_textEditingController.text.trim())
                          : null,
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;

    _textEditingController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
      uuid: authService.usuario.uuid,
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    newMessage.animationController.forward();

    setState(() {
      _isTyping = false;
      _chatMessages.insert(0, newMessage);
    });

    this.socketService.emit('mensaje-personal', {
      'from': this.authService.usuario.uuid,
      'to': this.chatService.usuarioTo.uuid,
      'message': text
    });
  }

  void _cargarHistorial(String uuid) async {
    List<Message> mensajes = await this.chatService.getChat(uuid);
    final historial = mensajes.map((m) => new ChatMessage(
        text: m.message,
        uuid: m.from,
        animationController: new AnimationController(
            vsync: this, duration: Duration(milliseconds: 300))
          ..forward()));
    setState(() {
      _chatMessages.insertAll(0, historial);
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _chatMessages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
