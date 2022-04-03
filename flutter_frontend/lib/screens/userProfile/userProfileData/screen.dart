import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/services/http_request.dart';
import 'package:flutter_crud_auth/sharedComponents/toastMessages/toastMessage.dart';

class UserProfileData extends StatefulWidget {
  Future Function() getUserData;
  UserProfileData({Key? key, required this.getUserData}) : super(key: key);

  @override
  State<UserProfileData> createState() => _UserProfileDataState();
}

class _UserProfileDataState extends State<UserProfileData> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController uuidController = TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController descriptionController =
      TextEditingController(text: "");

  void getProfileData() {
    widget.getUserData().then((data) {
      emailController
        ..text = data["email"]
        ..selection = TextSelection.collapsed(offset: data["email"].length);
      nameController
        ..text = data["name"]
        ..selection = TextSelection.collapsed(offset: data["name"].length);
      descriptionController
        ..text = data["description"]
        ..selection =
            TextSelection.collapsed(offset: data["description"].length);
      uuidController.text = data["uuid"];
    });
  }

  void updateUserData() {
    exeFetch(
        uri: "/api/user/",
        method: "put",
        body: jsonEncode({
          "email": emailController.text,
          "name": nameController.text,
          "description": descriptionController.text,
        }),
        navigateToIfNotAllowed: () =>
            Navigator.pushReplacementNamed(context, "/")).then((data) {
      ToastMessage.success(jsonDecode(data["body"])["msg"] ?? data.toString());
      // getProfileData();
    }).catchError((e) =>
        // ignore: invalid_return_type_for_catch_error
        ToastMessage.error(jsonDecode(e["body"])["msg"] ?? e.toString()));
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
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
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 20.0),
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
    );
  }
}
