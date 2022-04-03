import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_crud_auth/services/secure_store.dart';
import 'package:flutter_crud_auth/services/temp_store.dart';

import 'package:flutter_crud_auth/screens/login/screen.dart';
import 'package:flutter_crud_auth/screens/signUp/screen.dart';
import 'package:flutter_crud_auth/screens/userProfile/screen.dart';

Future<void> loadENV() {
  const RELEASE_MODE = String.fromEnvironment("RELEASE_MODE");
  if (RELEASE_MODE == "true") {
    return dotenv.load(fileName: "assets/env/.env_prod");
  } else {
    return dotenv.load(fileName: "assets/env/.env");
  }
}

void main() async {
  await loadENV();
  initSecureStore();
  temp_store_reset();
  Map<String, String> env_values = dotenv.env;
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => LoginScreen(env_values: env_values),
      "/sign_up": (context) => SignUP(env_values: env_values),
      "/user_profile": (context) => UserProfile(env_values: env_values),
    },
  ));
}
