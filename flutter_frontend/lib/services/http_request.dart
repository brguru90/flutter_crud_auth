import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    body = const {},
     Map<String,dynamic> header = const {
      "Content-Type": "application/json",
    }}) async {
  if (uri.startsWith("/")) {
    uri = uri.substring(1);
  }
  // uri =
  //     """${dotenv.env["SERVER_PROTOCOL"]}://${dotenv.env["SERVER_HOST"]}:${dotenv.env["SERVER_PORT"]}/$uri""";
  var client = HttpClient();
  late HttpClientRequest request;

  try {
    switch (method) {
      case "post":
        request = await client.post(dotenv.env["SERVER_HOST"].toString(), int.parse(dotenv.env["SERVER_PORT"].toString()), uri);
        break;
      case "put":
        request = await client.put(dotenv.env["SERVER_HOST"].toString(), int.parse(dotenv.env["SERVER_PORT"].toString()), uri);
        break;
      case "delete":
        request = await client.delete(dotenv.env["SERVER_HOST"].toString(), int.parse(dotenv.env["SERVER_PORT"].toString()), uri);
        break;
      default:
        request = await client.get(dotenv.env["SERVER_HOST"].toString(), int.parse(dotenv.env["SERVER_PORT"].toString()), uri);
    }

    header.forEach((key, value) {      
      request.headers.add(key, value);
    });        
    request.write(body);

    HttpClientResponse response = await request.close();


    print('Response status: ${response.statusCode}');
    print(response.headers);
    print(response.cookies.map((e) => e).length);
    final stringData=await response.transform(utf8.decoder).join();
    print('Response body2: $stringData');
    // var _cookie=Cookie.fromSetCookieValue(response.headers["set-cookie"].toString());
    // print(_cookie);
    // print(_cookie.name);

    return jsonDecode(stringData);
  } catch (e) {
    print(e);
    return {};
  } finally {
    client.close();
  }
}
