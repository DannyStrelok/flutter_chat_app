import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/global/env.dart';
import 'package:flutter_chat_app/src/models/login_response.dart';
import 'package:flutter_chat_app/src/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool value) {
    this._autenticando = value;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {"email": email.trim(), "password": password.trim()};

    final response = await http.post('${Env.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.usuario = loginResponse.usuario;
      this.autenticando = false;

      await this._saveToken(loginResponse.token);

      return true;
    } else {
      this.autenticando = false;
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    this.autenticando = true;
    final data = {
      "nombre": name.trim(),
      "email": email.trim(),
      "password": password.trim()
    };

    final response = await http.post('${Env.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.usuario = loginResponse.usuario;
      this.autenticando = false;

      await this._saveToken(loginResponse.token);

      return true;
    } else {
      this.autenticando = false;
      final respBody = jsonDecode(response.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    final resp = await http.get('${Env.apiUrl}/login/renew',
        headers: {'Authorization': token, 'Content-Type': 'application/json'});

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._saveToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
