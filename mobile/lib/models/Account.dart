import 'package:flutter/cupertino.dart';

class Account {
  String username;
  String password;
  String email;

  Account({
    required this.username,
    required this.password,
    required this.email,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'],
      password: json['password'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email
    };
  }
}
