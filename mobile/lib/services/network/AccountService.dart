import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile/services/WebSocketClient.dart';
import 'package:mobile/services/network/NetworkException.dart';
import 'package:mobile/models/Account.dart';
import 'package:mobile/state/AccountState.dart';
import 'package:mobile/utils/Constants.dart' as Constants;
import 'package:mobile/utils/CustomHttpClient.dart';
import 'package:mobile/utils/NetworkUtils.dart';
class AccountService {

  final String baseUrl = "http://${Constants.baseUrl}";
  final CustomHttpClient httpClient = CustomHttpClient();

  Future<Account> getAccount(String username) async {
    try {
      final response = await httpClient.get(
        Uri.parse("$baseUrl/account/$username")
      );
      return handleResponse(response);
    } catch (e) {
      if (e is SocketException) {
        throw FetchDataException(e.message);
      } else {
        rethrow;
      }
    }
  }

  Future<Account> login(String username, String password) async {
    try {
      final response = await httpClient.post(
        Uri.parse("$baseUrl/account/login"),
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password
        })
      );
      if(response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return Account.fromJson(json);
      }
      return handleResponse(response);
    } catch (e) {
      if (e is SocketException) {
        throw FetchDataException(e.message);
      } else {
        rethrow;
      }
    }
  }

  Future<Account> register(String username, String email, String password) async {
    try {
      final response = await httpClient.post(
        Uri.parse("$baseUrl/account/register"),
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
          'email': email,
        }),
      );
      if(response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        return Account.fromJson(json);
      }
      return handleResponse(response);
    } catch (e) {
       if (e is SocketException) {
         throw FetchDataException(e.message);
       } else {
         rethrow;
      }
    }
  }

  Future<void> logout() async {
    try {
      final response = await httpClient.post(
        Uri.parse("$baseUrl/account/logout")
      );
      return handleResponse(response);
    } catch (e) {
      if (e is SocketException) {
        throw FetchDataException(e.message);
      } else {
        rethrow;
      }
    }
  }
}