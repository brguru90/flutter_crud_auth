import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud_auth/services/http_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkExistingSession();
  }

  void checkExistingSession() {
    exeFetch(
      uri: "/api/login_status/",
    )
    .then((value) =>Navigator.pushReplacementNamed( context, "/user_profile"));
  }

  void Login() async {
    if (_formKey.currentState!.validate()) {
      exeFetch(
        uri: "/api/login/",
        method: "post",
        body: jsonEncode({
          "email": emailController.text,
        }),
      )
          .then((value) =>
              // Navigator.pushReplacementNamed(context, "/user_profile"))
               Navigator.pushNamed(context, "/user_profile"))
          .catchError((e) => Fluttertoast.showToast(
              msg: e.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0));
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
              ElevatedButton(
                onPressed: Login,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.login),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("Login")
                    ]),
              ),
              SizedBox(height: 40.0),
              Container(
                // color: Colors.green[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("New user?"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                // fixedSize: Size.fromHeight(1),
                                minimumSize: Size(0, 1),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/sign_up'),
                              child: Text(
                                "Click here",
                                // style: TextStyle(height: 0.1),
                              )),
                        ),
                        Text(" to sign up"),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
