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
  Map profileData = {};
  Map pendingRequests = {};
  int currentTab = 0;
  late Timer timerIntervalToCheckLoginStatus;

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

  Future getUserData() {
    Completer c = Completer();
    exeFetch(
        uri: "/api/user/",
        navigateToIfNotAllowed: () =>
            Navigator.pushReplacementNamed(context, "/")).then((data) {
      setState(() {
        profileData = jsonDecode(data["body"])["data"];
      });
      c.complete(jsonDecode(data["body"])["data"]);
    }).catchError((e) => c.completeError(e));
    return c.future;
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
    timerIntervalToCheckLoginStatus =
        Timer.periodic(const Duration(seconds: 10), (timer) {
      if (pendingRequests["login_status"] == null) {
        checkExistingSession();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timerIntervalToCheckLoginStatus.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: TextButton(
                  style: TextButton.styleFrom(
                    primary: currentTab == 0 ? Colors.blue[800] : Colors.black,
                    alignment: Alignment.centerLeft,
                    enableFeedback: false,
                    // fixedSize: Size.fromHeight(1),
                    minimumSize: Size(0, 1),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => setState(() {
                        currentTab = 0;
                      }),
                  child: const Text(
                    "Profile",
                    // style: TextStyle(height: 0.1),
                  )),
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: TextButton(
                  style: TextButton.styleFrom(
                    primary: currentTab == 1 ? Colors.blue[800] : Colors.black,
                    alignment: Alignment.centerLeft,
                    // fixedSize: Size.fromHeight(1),
                    minimumSize: Size(0, 1),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => setState(() {
                        currentTab = 1;
                      }),
                  child: const Text(
                    "Active sessions",
                    // style: TextStyle(height: 0.1),
                  )),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
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
          child: (() {
            switch (currentTab) {
              case 0:
                return UserProfileData(getUserData: getUserData);
              case 1:
                return UserActiveSessions();
              default:
                return UserProfileData(getUserData: getUserData);
            }
          })()),
    );
  }
}
