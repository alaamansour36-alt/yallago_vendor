import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  String? _token;

  void updateToken(String? token) {
    _token = token;
  }

  Future<dynamic> get(String path) => _send('GET', path);

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) =>
      _send('POST', path, body: body);

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) =>
      _send('PUT', path, body: body);

  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) =>
      _send('PATCH', path, body: body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(String method, String path,
      {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    print('API Request: $method $uri');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_token != null && _token!.isNotEmpty)
        'Authorization': 'Bearer $_token',
    };

    late final http.Response response;
    final encodedBody = body == null ? null : jsonEncode(body);

    switch (method) {
      case 'GET':
        response = await _httpClient.get(uri, headers: headers);
      case 'POST':
        response =
            await _httpClient.post(uri, headers: headers, body: encodedBody);
      case 'PUT':
        response =
            await _httpClient.put(uri, headers: headers, body: encodedBody);
      case 'PATCH':
        response =
            await _httpClient.patch(uri, headers: headers, body: encodedBody);
      case 'DELETE':
        response = await _httpClient.delete(uri, headers: headers);
      default:
        throw ApiException('Unsupported method: $method');
    }

    final dynamic decoded =
        response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        return decoded['data'];
      }
      return decoded;
    }

    final message = decoded is Map<String, dynamic>
        ? (decoded['message'] ?? decoded['error'] ?? 'Request failed')
            .toString()
        : 'Request failed';
    throw ApiException(message, statusCode: response.statusCode);
  }

  String _normalizePath(String path) {
    final uri = Uri.parse(path);
    final normalizedPath = uri.path.endsWith('/') ? uri.path : '${uri.path}/';

    return uri.replace(path: normalizedPath).toString();
  }
}
