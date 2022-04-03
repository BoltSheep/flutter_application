import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/presentation/drawer_icon_icons.dart';
import 'package:flutter_application/presentation/microscope_icon_icons.dart';
import 'package:flutter_application/presentation/out_icon_icons.dart';
import 'package:flutter_application/presentation/spreadsheet_icon_icons.dart';

import '../../Results/results_screen.dart';

class Body extends StatelessWidget {
  final String name;
  const Body({
    Key? key,
    this.name = 'Emanuelle',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/images/default-user-image.png"),
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
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: size.height * 0.04),
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Olá, \n${name}!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.06),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              primary: kLightGreyColor,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
            icon: CustomIcons(icon: MicroscopeIcon.microscope),
            label: Text(
              "Realizar Captura",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: size.height * 0.06),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  primary: kPrimaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ResultsScreen();
                      },
                    ),
                  );
                },
                child: Column(
                  children: [
                    CustomIcons(icon: SpreadsheetIcon.spreadsheet),
                    Text(
                      "Resultados",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.06),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  primary: kRedLightColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
                child: Column(
                  children: [
                    CustomIcons(icon: DrawerIcon.drawer),
                    Text(
                      "Banco de Apoio",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomIcons extends StatelessWidget {
  final IconData icon;
  const CustomIcons({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: Colors.white,
        child: Icon(
          icon,
          color: kVeryDarkGreyColor,
          size: 50,
        ),
      ),
    );
  }
}
