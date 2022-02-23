import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Client {
  static const String baseUrl = 'https://api.themoviedb.org';
  static const String authority = 'api.themoviedb.org';

  static Future<Map<String, dynamic>?> get({String? path, Map<String, dynamic>? params}) async {
    if (path == null) throw 'encodePath can not null';
    http.Response response = await http.get(Uri.https(authority, path, params));
    if (response.statusCode == 200) {
      log('$path - ${jsonEncode(params)}', name: 'HTTP LOG');
      return jsonDecode(response.body);
    }
  }
}
