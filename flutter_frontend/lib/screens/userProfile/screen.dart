import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/services/http_request.dart';

class UserProfile extends StatefulWidget {
  final Map<String, String> env_values;
  const UserProfile({Key? key, Map<String, String> this.env_values = const {}})
      : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  Map userProfileData={};

  void checkExistingSession() {
    exeFetch(
      uri: "/api/login_status/",
    ).catchError((e) => Navigator.pushReplacementNamed(context, "/"));
  }

  void Logout() {
    exeFetch(
      uri: "/api/user/logout/",
    )
        .then((value) => Navigator.pushReplacementNamed(context, "/"))
        .catchError((e) => print(e));
  }

  void getUserData(){
    exeFetch(
      uri: "/api/user/",
      navigateToOnError: ()=>Navigator.pushReplacementNamed(context, "/")
    )
        .then((data) => setState(()=>userProfileData=jsonDecode(data["body"])["data"]));
  }

  @override
  void initState() {
    super.initState();
    checkExistingSession();
    getUserData();
    Timer.periodic(new Duration(seconds: 5), (timer) {
      checkExistingSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("User profile"),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[400],
                  ),
                  onPressed: Logout,
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 10.0),
                      Text("Logout"),
                    ],
                  ))
            ],
          ),
          // automaticallyImplyLeading: false,
          // centerTitle: true,
        ),
        body: Container(
          child: Text(jsonEncode(userProfileData)),
        ));
  }
}
