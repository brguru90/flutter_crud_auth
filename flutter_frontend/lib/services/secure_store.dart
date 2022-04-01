import 'package:flutter_secure_storage/flutter_secure_storage.dart';

var storage = null;

void initSecureStore() async {
  storage = new FlutterSecureStorage();

  // print("${await storage.readAll()}");
}
