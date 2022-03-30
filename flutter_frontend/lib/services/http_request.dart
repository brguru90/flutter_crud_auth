import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<dynamic, dynamic>> exeFetch(
    {required String uri,
    method = "get",
    body = const {},
    header = const {
      "Content-Type": "application/json",
    }}) async {
  if (uri.startsWith("/")) {
    uri = uri.substring(1);
  }
  uri =
      """${dotenv.env["SERVER_PROTOCOL"]}://${dotenv.env["SERVER_HOST"]}:${dotenv.env["SERVER_PORT"]}/$uri""";
  var url = Uri.parse(uri);

  print("exeFetch: " + uri);
  print("body: " + body);
  late http.Response response;

  try {
    switch (method) {
      case "post":
        response = await http.post(url, body: body, headers: header);
        break;
      case "put":
        response = await http.put(url, body: body, headers: header);
        break;
      case "delete":
        response = await http.delete(url, body: body, headers: header);
        break;
      default:
        response = await http.get(url, headers: header);
    }

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return jsonDecode(response.body);
  } catch (e) {
    print(e);
    return {};
  }
}
