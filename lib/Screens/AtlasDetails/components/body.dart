import 'package:flutter/material.dart';

import '../../../components/drop_down.dart';
import '../../../components/top_main_menus.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          TopMainMenusWidget(),
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                'Atlas',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          DropDownWidget(),
          // Mock images
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/result-image-mock.png',
              width: size.width * 0.85,
              height: size.height * 0.35,
            ),
          ),
        ],
      ),
    );
  }
}
