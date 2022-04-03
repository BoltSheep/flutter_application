import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/presentation/google_icon_icons.dart';

class RoundedButtonGoogle extends StatelessWidget {
  const RoundedButtonGoogle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.7,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: newElevatedButton(),
      ),
    );
  }

  ElevatedButton newElevatedButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: kGreyColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
        textStyle: const TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      onPressed: () {},
      icon: Icon(
        GoogleIcon.google,
        color: kPrimaryColor,
      ),
      label: Text(
        "Faça login com Google",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
