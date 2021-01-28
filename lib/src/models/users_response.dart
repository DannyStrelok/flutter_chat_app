// To parse this JSON data, do
//
//     final usersResponse = usersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_chat_app/src/models/usuario.dart';

UsersResponse usersResponseFromJson(String str) => UsersResponse.fromJson(json.decode(str));

String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
  UsersResponse({
    this.ok,
    this.users,
  });

  bool ok;
  List<Usuario> users;

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
    ok: json["ok"],
    users: List<Usuario>.from(json["users"].map((x) => Usuario.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

