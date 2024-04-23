import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/network/NetworkException.dart';

dynamic handleResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return jsonDecode(response.body);
    case 204:
      return;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
      throw UnauthorisedException(response.body.toString());
    case 403:
      throw ForbiddenException(response.body.toString());
    case 404:
      throw NotFoundException(response.body.toString());
    case 409:
      throw ConflictException(response.body.toString());
    case 500:
      throw InternalServerErrorException(response.body.toString());
    default:
      throw FetchDataException(
          'Error occured while communication with server with status code : ${response.statusCode}');
  }
}