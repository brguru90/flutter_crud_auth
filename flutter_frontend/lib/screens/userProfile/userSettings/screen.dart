import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/sharedComponents/toastMessages/toastMessage.dart';
import 'package:flutter_crud_auth/services/http_request.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  void removeAccount() {
    exeFetch(uri: "/api/user/", method: "delete")
        .then((value) => Navigator.pushReplacementNamed(context, "/"))
        .catchError((e) =>
            ToastMessage.error(jsonDecode(e["body"])["msg"] ?? e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red[400],
              ),
              onPressed: removeAccount,
              child: Row(
                children: const [
                  Icon(Icons.delete_forever),
                  SizedBox(width: 10.0),
                  Text("Delete account"),
                ],
              )),
        ],
      ),
    );
  }
}
