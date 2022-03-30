import 'package:flutter/material.dart';

class LabeledInput extends StatefulWidget {
  const LabeledInput({Key? key, initialValue="",}) : super(key: key);

  @override
  State<LabeledInput> createState() => _LabeledInputState();
}

class _LabeledInputState extends State<LabeledInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).cursorColor,
      initialValue: 'Input text',
      maxLength: 20,
      decoration: const InputDecoration(
        icon: Icon(Icons.email),
        labelText: 'Label text',
        labelStyle: TextStyle(
          color: Color(0xFF6200EE),
        ),
        helperText: 'Helper text',
        suffixIcon: Icon(
          Icons.check_circle,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
        ),
      ),
    );
  }
}
