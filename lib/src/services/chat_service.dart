import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/global/env.dart';
import 'package:flutter_chat_app/src/models/mensajes_response.dart';
import 'package:flutter_chat_app/src/models/usuario.dart';
import 'package:flutter_chat_app/src/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {

  Usuario usuarioTo;

  Future<List<Message>> getChat(String userId) async {
    final response = await http.get('${Env.apiUrl}/mensajes/${userId}',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await AuthService.getToken()
      }
    );

    final mensajesResponse = mensajesResponseFromJson(response.body);

    return mensajesResponse.messages;

  }

}