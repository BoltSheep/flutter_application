import 'package:flutter/material.dart';

import '../../../components/rounded_button.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isCheckedProfessor = false;
  bool isCheckedAluno = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 60),
              child: Text(
                'Olá, \nCadastre-se!',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          RegisterLabels(label: 'Nome:'),
          RegisterTextField(),
          RegisterLabels(label: 'Email:'),
          RegisterTextField(),
          RegisterLabels(label: 'Senha:'),
          RegisterTextField(),
          RegisterLabels(label: 'Confirmar senha:'),
          RegisterTextField(),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 50),
                child: Checkbox(
                  value: isCheckedProfessor,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedProfessor = value!;
                    });
                  },
                ),
              ),
              Text(
                'Sou professor(a)',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 50),
                child: Checkbox(
                  value: isCheckedAluno,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedAluno = value!;
                    });
                  },
                ),
              ),
              Text(
                'Sou aluno(a)',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          RoundedButton(
            text: "Cadastrar",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class RegisterLabels extends StatelessWidget {
  final String label;
  const RegisterLabels({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      width: size.width * 0.75,
      decoration: BoxDecoration(
        color: kGreyColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) {},
        scrollPadding: EdgeInsets.symmetric(horizontal: 20),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
