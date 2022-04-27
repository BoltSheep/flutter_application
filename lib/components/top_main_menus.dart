import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/Welcome/welcome_screen.dart';

class TopMainMenusWidget extends StatelessWidget {
  const TopMainMenusWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/default-user-image.png"),
            radius: 30,
          ),
        ),
        SizedBox(width: size.width * 0.4),
        GestureDetector(
          child: Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/out.png"),
                  scale: 1.5,
                ),
              )),
          onTap: () {
            _signOut(context);
          },
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(),
      ),
    );
  }
}
