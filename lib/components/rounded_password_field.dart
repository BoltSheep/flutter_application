import 'package:flutter/material.dart';
import 'package:flutter_application/components/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  get kBlueColor => null;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kBlueColor,
          ),
          suffixIcon: Icon(Icons.visibility),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
