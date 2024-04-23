import 'package:http/http.dart' as http;

class CustomHttpClient {
  static CustomHttpClient? _instance;

  Map<String, String> headers = {
    'content-type': 'application/json; charset=UTF-8'
  };

  CustomHttpClient._internal();
  factory CustomHttpClient() {
    _instance ??= CustomHttpClient._internal();
    return _instance!;
  }

  void _updateSessionId(http.Response response) {
    String? newSessionId = response.headers['set-cookie'];
    if (newSessionId == null) return;

    int index = newSessionId.indexOf(';');
    headers['cookie'] = (index == -1) ? newSessionId : newSessionId.substring(0, index);
  }

  String? getSessionId() {
    return headers['cookie'];
  }

  Future<http.Response> get(Uri url) async {
    http.Response response = await http.get(url, headers: headers);
    _updateSessionId(response);
    return response;
  }

  Future<http.Response> post(Uri url, {dynamic body}) async {
    http.Response response = await http.post(url, headers: headers, body: body);
    _updateSessionId(response);
    return response;
  }

  Future<http.Response> put(Uri url, {dynamic body}) async {
    http.Response response = await http.put(url, headers: headers, body: body);
    _updateSessionId(response);
    return response;
  }
}