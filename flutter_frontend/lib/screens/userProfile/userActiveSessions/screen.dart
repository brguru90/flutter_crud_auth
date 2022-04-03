import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/services/http_request.dart';
import './activeSessionCard.dart';

class UserActiveSessions extends StatefulWidget {
  const UserActiveSessions({Key? key}) : super(key: key);

  @override
  State<UserActiveSessions> createState() => _UserActiveSessionsState();
}

class _UserActiveSessionsState extends State<UserActiveSessions> {
  List activeSessions = [];

  void getActiveSessions() {
    exeFetch(
        uri: "/api/user/",
        navigateToIfNotAllowed: () =>
            Navigator.pushReplacementNamed(context, "/")).then((data) {
      print(data);
      setState(() {
        activeSessions = jsonDecode(data["body"])["data"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getActiveSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Update Profile Data",
                style: TextStyle(fontSize: 30.0, color: Colors.blue[700]),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [activeSessionCard()])
            ]));
  }
}
