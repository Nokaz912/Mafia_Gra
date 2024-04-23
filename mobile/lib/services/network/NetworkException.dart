class NetworkException implements Exception {
  final _message;
  final _prefix;

  NetworkException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends NetworkException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends NetworkException {
  BadRequestException([message]) : super(message, "(400) Invalid: ");
}

class UnauthorisedException extends NetworkException {
  UnauthorisedException([message]) : super(message, "(401) Unauthorised: ");
}

class ForbiddenException extends NetworkException {
  ForbiddenException([message]) : super(message, "(403) Forbidden: ");
}

class NotFoundException extends NetworkException {
  NotFoundException([message]) : super(message, "(404) Not found: ");
}

class ConflictException extends NetworkException {
  ConflictException([message]) : super(message, "(409) Conflict: ");
}

class InternalServerErrorException extends NetworkException {
  InternalServerErrorException([message]) : super(message, "(500) Internal server error: ");
}

class InvalidInputException extends NetworkException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}