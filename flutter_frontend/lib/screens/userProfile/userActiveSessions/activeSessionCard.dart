import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/services/http_request.dart';
import 'package:flutter_crud_auth/sharedComponents/toastMessages/toastMessage.dart';

class activeSessionCard extends StatelessWidget {
  Map activeSession = {};
  Function getActiveSessions = () {};
  activeSessionCard(
      {Key? key,
      this.activeSession = const {},
      required this.getActiveSessions})
      : super(key: key);

  void blockSession({required token_id, required exp}) {
    exeFetch(
      uri: "/api/user/block_token/",
      method: "post",
      body: jsonEncode({
        "token_id": token_id,
        "exp": exp,
      }),
    ).then((body) {
      ToastMessage.success(jsonDecode(body["body"])["msg"] ?? body.toString());
      getActiveSessions();
    }).catchError((e) =>
        ToastMessage.error(jsonDecode(e["body"])["msg"] ?? e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Token ID:",
                    style: TextStyle(color: Colors.blue[700], fontSize: 16.0),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Tooltip(
                      message: activeSession["token_id"],
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                            colors: <Color>[Colors.amber, Colors.red]),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 40.0),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      showDuration: const Duration(seconds: 2),
                      preferBelow: false,
                      child: Text(
                        activeSession["token_id"],
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text(
                    "IP:",
                    style: TextStyle(color: Colors.blue[700], fontSize: 16.0),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    activeSession["ip"],
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text(
                    "Expiry:",
                    style: TextStyle(color: Colors.blue[700], fontSize: 16.0),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(activeSession["exp"])
                        .toLocal()
                        .toIso8601String(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Text(
                    "Status:",
                    style: TextStyle(color: Colors.blue[700], fontSize: 16.0),
                  ),
                  SizedBox(width: 20.0),
                  Text(
                    activeSession["status"],
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor: activeSession["status"] == "active"
                              ? Colors.blue[700]
                              : Colors.blue[200],
                          // fixedSize: Size.fromHeight(1),
                          minimumSize: const Size(0, 1),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 7.0)),
                      onPressed: () async => activeSession["status"] == "active"
                          ? blockSession(
                              token_id: activeSession["token_id"],
                              exp: activeSession["exp"])
                          : null,
                      child: Row(
                        children: const [
                          Text(
                            "Block",
                            // style: TextStyle(height: 0.1),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(Icons.block, size: 16.0),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
