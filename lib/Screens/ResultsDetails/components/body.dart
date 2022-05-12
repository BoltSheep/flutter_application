import 'package:flutter/material.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  final String titulo;
  const Body({Key? key, required this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                titulo,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          // Mockados:
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/result-image-mock.png',
              width: size.width * 0.85,
              height: size.height * 0.35,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                "Descrição",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Container(
            color: kGreyColor,
            width: size.width * 0.85,
            height: size.height * 0.05,
            child: Text("teste"),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                "Resultado",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Container(
            color: kGreyColor,
            width: size.width * 0.85,
            height: size.height * 0.05,
            child: Text("teste resultado"),
          )
        ],
      ),
    );
  }
}
