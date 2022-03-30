import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/screens/login/screen.dart';
import 'package:flutter_crud_auth/screens/signUp/screen.dart';
import 'package:flutter_crud_auth/screens/userProfile/screen.dart';


void main(){
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/":(context) => LoginScreen(),
      "/sign_up":(context) => SignUP(),
      "/user_profile":(context) => UserProfile(),
    },
  ));
}