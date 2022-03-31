import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_crud_auth/services/secure_store.dart';
import 'package:flutter_crud_auth/services/temp_store.dart';

// Future<Map<dynamic, dynamic>> exeFetch(
//     {required String uri,
//     method = "get",
//     body = const {},
//     header = const {
//       "Content-Type": "application/json",
//     }}) async {
//   if (uri.startsWith("/")) {
//     uri = uri.substring(1);
//   }
//   uri =
//       """${dotenv.env["SERVER_PROTOCOL"]}://${dotenv.env["SERVER_HOST"]}:${dotenv.env["SERVER_PORT"]}/$uri""";
//   var url = Uri.parse(uri);

//   print("exeFetch: " + uri);
//   print("body: " + body);
//   late http.Response response;

//   try {
//     switch (method) {
//       case "post":
//         response = await http.post(url, body: body, headers: header);
//         break;
//       case "put":
//         response = await http.put(url, body: body, headers: header);
//         break;
//       case "delete":
//         response = await http.delete(url, body: body, headers: header);
//         break;
//       default:
//         response = await http.get(url, headers: header);
//     }

//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//     print(response.headers);
//     // var _cookie=Cookie.fromSetCookieValue(response.headers["set-cookie"].toString());
//     // print(_cookie);
//     // print(_cookie.name);

//     return jsonDecode(response.body);
//   } catch (e) {
//     print(e);
//     return {};
//   }
// }

Future<Map<dynamic, dynamic>> exeFetch(
    {required String uri,
    method = "get",
    body = null,
    Map<String, dynamic> header = const {
      "Content-Type": "application/json",
    },
    navigateTo = null}) async {
  if (navigateTo == null) {
    navigateTo = () {};
  }

  if (uri.startsWith("/")) {
    uri = uri.substring(1);
  }
  var client = HttpClient();
  late HttpClientRequest request;

  try {
    switch (method) {
      case "post":
        request = await client.post(dotenv.env["SERVER_HOST"].toString(),
            int.parse(dotenv.env["SERVER_PORT"].toString()), uri);
        break;
      case "put":
        request = await client.put(dotenv.env["SERVER_HOST"].toString(),
            int.parse(dotenv.env["SERVER_PORT"].toString()), uri);
        break;
      case "delete":
        request = await client.delete(dotenv.env["SERVER_HOST"].toString(),
            int.parse(dotenv.env["SERVER_PORT"].toString()), uri);
        break;
      default:
        request = await client.get(dotenv.env["SERVER_HOST"].toString(),
            int.parse(dotenv.env["SERVER_PORT"].toString()), uri);
    }
    // ------------ constructing request --------------------

    header.forEach((key, value) {
      request.headers.add(key, value);
    });

    String cookies =
        temp_store["cookies"] ?? await storage.read(key: "cookies") ?? "";
    if (cookies != "") {
      temp_store["cookies"] = cookies;
      List cookies_obj = jsonDecode(cookies);
      cookies_obj.forEach((cookie) {
        request.cookies.add(Cookie.fromSetCookieValue(cookie));
      });
    }

    if (temp_store["csrf_token"] != null) {
      request.headers.add("csrf_token", temp_store["csrf_token"]);
    }

    if (body != null) {
      request.write(body);
    }

    print("request.headers ${request.headers}");
    HttpClientResponse response = await request.close();

    // ------------ reading response --------------------

    if (response.headers.value("csrf_token") != null) {
      temp_store["csrf_token"] =
          response.headers.value("csrf_token").toString();
    }

    if (response.cookies.length > 0) {
      String _cookies = jsonEncode(
          response.cookies.map((cookie) => cookie.toString()).toList());
      await storage.write(key: "cookies", value: _cookies);
      temp_store["cookies"] = _cookies;
    }

    final stringData = await response.transform(utf8.decoder).join();
    print(
        'uri=$uri => Response status: ${response.statusCode}\nResponse body2: $stringData');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Future<Map>.value(jsonDecode(stringData));
    } else if (response.statusCode == 401) {
      // throw Exception(Map.from({
      //   "body":stringData,
      //   "navigate":navigateTo()
      // }));
      return Future.error(
          Map.from({"body": stringData, "navigate": navigateTo()}));
    } else {
      return Future.error(Map.from({
        "err": response.statusCode,
        "body": stringData,
        "navigate": navigateTo()
      }));
    }
  } catch (e, stacktrace) {
    print(e);
    print(stacktrace);
    return {};
  } finally {
    client.close();
  }
}
