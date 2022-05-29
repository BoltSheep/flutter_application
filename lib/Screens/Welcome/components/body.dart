import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/Screens/Menus/menus_screen.dart';
import 'package:flutter_application/Screens/Welcome/components/background.dart';
import 'package:flutter_application/components/register_button.dart';
import 'package:flutter_application/components/rounded_button.dart';
import 'package:flutter_application/components/rounded_input_field.dart';
import 'package:flutter_application/components/rounded_password_field.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/provider/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Login function
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    // This size provide us total height and width of our screen
    Size size = MediaQuery.of(context).size;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.5),
            RoundedInputField(
              hintText: "Email",
              onChanged: (value) {},
              controller: _emailController,
            ),
            SizedBox(height: size.height * 0.02),
            RoundedPasswordField(
              onChanged: (value) {},
              controller: _passwordController,
            ),
            SizedBox(height: size.height * 0.02),
            RoundedButton(
              text: "Entrar",
              press: () async {
                User? user = await loginUsingEmailPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                    context: context);
                if (user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const MenusScreen(),
                  ));
                }
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
            ElevatedButton.icon(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
              icon: const FaIcon(FontAwesomeIcons.google, color: kPrimaryColor),
              label: const Text('Faça login com Google',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
              style: ElevatedButton.styleFrom(
                primary: kGreyColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            const RegisterButton(),
          ],
        ),
      ),
    );
  }
}
