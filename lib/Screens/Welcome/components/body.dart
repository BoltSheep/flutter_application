import 'package:flutter/material.dart';
import 'package:flutter_application/Screens/Menus/menus_screen.dart';
import 'package:flutter_application/Screens/Welcome/components/background.dart';
import 'package:flutter_application/components/register_button.dart';
import 'package:flutter_application/components/rounded_button.dart';
import 'package:flutter_application/components/rounded_button_google.dart';
import 'package:flutter_application/components/rounded_input_field.dart';
import 'package:flutter_application/components/rounded_password_field.dart';
import 'package:flutter_application/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This size provide us total height and width of our screen
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.5),
            RoundedInputField(
              hintText: "email",
              onChanged: (value) {},
            ),
            SizedBox(height: size.height * 0.02),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            SizedBox(height: size.height * 0.02),
            RoundedButton(
              text: "Entrar",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MenusScreen();
                    },
                  ),
                );
              },
            ),
            const Text(
              "ou",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kDarkGreyColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const RoundedButtonGoogle(),
            SizedBox(height: size.height * 0.02),
            const RegisterButton(),
          ],
        ),
      ),
    );
  }
}
