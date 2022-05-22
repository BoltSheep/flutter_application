import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/Screens/Atlas/atlas_screen.dart';
import 'package:flutter_application/Screens/SendCapture/send_capture_screen.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/model/user_model.dart';
import 'package:flutter_application/presentation/drawer_icon_icons.dart';
import 'package:flutter_application/presentation/microscope_icon_icons.dart';
import 'package:flutter_application/presentation/spreadsheet_icon_icons.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/top_main_menus.dart';
import '../../Results/results_screen.dart';

class Body extends StatefulWidget {
  final String name;
  const Body({
    Key? key,
    this.name = 'Emanuelle',
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);

      if (this.image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SendCaptureScreen(
                image: this.image!,
              );
            },
          ),
        );
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String? name = "Visitante";
    if (loggedInUser.name == null) {
      name = user!.displayName;
    } else {
      name = loggedInUser.name;
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TopMainMenusWidget(user: user),
          SizedBox(height: size.height * 0.04),
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Olá, \n$name!',
                textAlign: TextAlign.left,
                style: const TextStyle(
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
            onPressed: () {
              pickImage();
            },
            icon: const CustomIcons(icon: MicroscopeIcon.microscope),
            label: const Text(
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
                      const EdgeInsets.symmetric(horizontal: 38, vertical: 80),
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
                  children: const [
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
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 80),
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
                        return AtlasScreen();
                      },
                    ),
                  );
                },
                child: Column(
                  children: const [
                    CustomIcons(icon: DrawerIcon.drawer),
                    Text(
                      "Atlas",
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
