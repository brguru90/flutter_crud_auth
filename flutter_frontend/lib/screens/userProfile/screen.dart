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
  Map userProfileData = {};
  late Timer timer_to_getUserData;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController uuidController =
      new TextEditingController(text: "");
  final TextEditingController emailController =
      new TextEditingController(text: "");
  final TextEditingController nameController =
      new TextEditingController(text: "");
  final TextEditingController descriptionController =
      new TextEditingController(text: "");

  Map pendingRequests = {};

  void checkExistingSession() {
    if (pendingRequests["login_status"] != null) {
      try {
        pendingRequests["login_status"].abort();
      } catch (e) {}
    }
    exeFetch(
      uri: "/api/login_status/",
      getRequest: (req) => pendingRequests["login_status"] = req,
    ).catchError((e) => Navigator.pushReplacementNamed(context, "/"));
  }

  void Logout() {
    exeFetch(
      uri: "/api/user/logout/",
    )
        .then((value) => Navigator.pushReplacementNamed(context, "/"))
        .catchError((e) => print(e));
  }

  void getUserData() {
    exeFetch(
        uri: "/api/user/",
        navigateToOnError: () =>
            Navigator.pushReplacementNamed(context, "/")).then((data) {
      Map temp_data = jsonDecode(data["body"])["data"];
      emailController.text = temp_data["email"];
      nameController.text = temp_data["name"];
      descriptionController.text = temp_data["description"];
      uuidController.text = temp_data["uuid"];
    });
  }

  void updateUserData() {}

  @override
  void initState() {
    super.initState();
    checkExistingSession();
    getUserData();
    timer_to_getUserData = Timer.periodic(new Duration(seconds: 1), (timer) {
      checkExistingSession();
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Update Profile Data",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue[700]),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          enabled: false,
                          controller: uuidController,
                          cursorColor: Theme.of(context).cursorColor,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.numbers),
                            labelText: 'UUID',
                            labelStyle: TextStyle(
                              color: Color(0xFF6200EE),
                            ),
                            helperText: 'uuid',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: nameController,
                          cursorColor: Theme.of(context).cursorColor,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Enter Name',
                            labelStyle: TextStyle(
                              color: Color(0xFF6200EE),
                            ),
                            helperText: 'Ex: Guruprasad BR',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: emailController,
                          cursorColor: Theme.of(context).cursorColor,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: 'Enter Email Address',
                            labelStyle: TextStyle(
                              color: Color(0xFF6200EE),
                            ),
                            helperText: 'Ex: brguru90@gmail.com',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: descriptionController,
                          cursorColor: Theme.of(context).cursorColor,
                          textAlignVertical: TextAlignVertical.top,
                          maxLines: 5,
                          // scrollPadding: EdgeInsets.only(bottom:200),

                          decoration: const InputDecoration(
                            // prefixIcon: Padding( padding: const EdgeInsets.fromLTRB(0, 0, 20, 60), child: Icon(Icons.description)),
                            labelText: 'Enter Description',
                            labelStyle: TextStyle(
                              color: Color(0xFF6200EE),
                            ),
                            helperText: 'Ex: bla bla bla...',
                            // suffixIcon: Padding( padding: const EdgeInsets.fromLTRB(0, 0, 0, 60), child: Icon(Icons.check_circle)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF6200EE)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: updateUserData,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.save_as),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Update",
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
