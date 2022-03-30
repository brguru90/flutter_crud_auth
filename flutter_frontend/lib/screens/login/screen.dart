import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        automaticallyImplyLeading: false,
        centerTitle: true,
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
                cursorColor: Theme.of(context).cursorColor,
                initialValue: '',
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("ok");
                  } 
                  else {
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
