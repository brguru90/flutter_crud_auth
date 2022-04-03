import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/services/http_request.dart';
import 'package:flutter_crud_auth/sharedComponents/toastMessages/toastMessage.dart';
import './userProfileData/screen.dart';
import './userActiveSessions/screen.dart';

class UserProfile extends StatefulWidget {
  final Map<String, String> env_values;
  const UserProfile({Key? key, this.env_values = const {}}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map pendingRequests = {};
  late Timer timer_to_getUserData;

  void checkExistingSession() {
    // if (pendingRequests["login_status"] != null) {
    //   try {
    //     pendingRequests["login_status"].abort();
    //   } catch (e) {}
    // }
    exeFetch(
      uri: "/api/login_status/",
      getRequest: (req) => pendingRequests["login_status"] = req,
    )
        .then((value) => pendingRequests["login_status"] = null)
        .catchError((e) => Navigator.pushReplacementNamed(context, "/"));
  }

  void logout() {
    exeFetch(
      uri: "/api/user/logout/",
    )
        .then((value) => Navigator.pushReplacementNamed(context, "/"))
        .catchError((e) => print(e));
  }

  @override
  void initState() {
    super.initState();
    checkExistingSession();
    timer_to_getUserData = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (pendingRequests["login_status"] == null) {
        checkExistingSession();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer_to_getUserData.cancel();
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
                onPressed: logout,
                child: Row(
                  children: const [
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: const [UserProfileData(), UserActiveSessions()],
        ),
      ),
    );
  }
}
