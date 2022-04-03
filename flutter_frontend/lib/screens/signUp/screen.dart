import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_crud_auth/services/http_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignUP extends StatefulWidget {
  final Map<String, String> env_values;

  const SignUP({Key? key, Map<String, String> this.env_values = const {}})
      : super(key: key);

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
      new TextEditingController(text: "");
  final TextEditingController nameController =
      new TextEditingController(text: "");
  final TextEditingController descriptionController =
      new TextEditingController(text: "");

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      exeFetch(
        uri: "/api/sign_up/",
        method: "post",
        body: jsonEncode({
          "email": emailController.text,
          "name": nameController.text,
          "description": descriptionController.text,
        }),
      ).then((value) =>  Navigator.pushNamed(context, "/user_profile"));
    } else {
      print("not ok");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Signup"),
            Text("""APP_ENV=${widget.env_values["APP_ENV"]}""")
          ],
        ),
        // automaticallyImplyLeading: false,
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
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
                  onPressed: signUp,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.login),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Sign up",
                        )
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
