import 'package:flutter_chat_app/src/global/env.dart';
import 'package:flutter_chat_app/src/models/users_response.dart';
import 'package:flutter_chat_app/src/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_app/src/models/usuario.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuarios() async {

    try {

      final response = await http.get('${Env.apiUrl}/users',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await AuthService.getToken()
      });

      final usersResponse = usersResponseFromJson(response.body);

      return usersResponse.users;
      
    } catch(e) {
      return [];
    }

  }

}