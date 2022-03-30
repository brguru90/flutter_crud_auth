import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/services/http_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  final Map<String, String> env_values;

  const LoginScreen({Key? key, Map<String, String> this.env_values = const {}})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
      new TextEditingController(text: "");

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Login"),
            Text("""APP_ENV=${widget.env_values["APP_ENV"]}""")
          ],
        ),
        automaticallyImplyLeading: false,
        // centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: emailController,
                cursorColor: Theme.of(context).cursorColor,
                maxLength: 20,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'Enter Email Address',
                  labelStyle: TextStyle(
                    color: Color(0xFF6200EE),
                  ),
                  helperText: 'Ex: brguru90@gmail.com',
                  suffixIcon: Icon(
                    Icons.check_circle,
                  ),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await exeFetch(
                      uri: "/api/login/",
                      method: "post",
                      body: jsonEncode({
                        "email": emailController.text,
                      }),
                    );
                  } else {
                    print("not ok");
                  }
                },
                child: Wrap(children: const [
                  Icon(Icons.login),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("Login")
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
