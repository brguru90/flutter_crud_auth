import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final Map<String, String> env_values;
  const UserProfile({Key? key, Map<String, String> this.env_values = const {}})
      : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("User profile"),
              Text("""APP_ENV=${widget.env_values["APP_ENV"]}""")
            ],
          ),
          // automaticallyImplyLeading: false,
          // centerTitle: true,
        ),
        body: Container(
          child: Text("user profile"),
        ));
  }
}
