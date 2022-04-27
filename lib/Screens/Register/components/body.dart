import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../../model/user_model.dart';
import '../../Welcome/welcome_screen.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  bool isCheckedProfessor = false;
  bool isCheckedAluno = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Padding(
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
            const RegisterLabels(label: 'Nome:'),
            RegisterTextField(
              controller: nameEditingController,
              keyboardType: TextInputType.name,
              obscureText: false,
              validator: (value) {
                RegExp regex = new RegExp(r'^.{3,}$');
                if (value!.isEmpty) {
                  return ("Nome não pode ser vazio");
                }
                if (!regex.hasMatch(value)) {
                  return ("Utilize um nome válido(Min. 3 Caracteres)");
                }
                return null;
              },
            ),
            const RegisterLabels(label: 'Email:'),
            RegisterTextField(
              controller: emailEditingController,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Por favor insira um email");
                }
                // reg expression for email validation
                if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                    .hasMatch(value)) {
                  return ("Por favor insira um email válido");
                }
                return null;
              },
            ),
            const RegisterLabels(label: 'Senha:'),
            RegisterTextField(
              controller: passwordEditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              validator: (value) {
                RegExp regex = new RegExp(r'^.{6,}$');
                if (value!.isEmpty) {
                  return ("A senha é obrigatória");
                }
                if (!regex.hasMatch(value)) {
                  return ("Insira uma senha válida(Min. 6 Caracteres)");
                }
              },
            ),
            const RegisterLabels(label: 'Confirmar senha:'),
            RegisterTextField(
              controller: confirmPasswordEditingController,
              keyboardType: TextInputType.text,
              obscureText: true,
              validator: (value) {
                if (confirmPasswordEditingController.text !=
                    passwordEditingController.text) {
                  return "Senhas não são as mesmas";
                }
                return null;
              },
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Checkbox(
                    value: isCheckedProfessor,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedProfessor = value!;
                      });
                    },
                  ),
                ),
                const Text(
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
                  padding: const EdgeInsets.only(left: 50),
                  child: Checkbox(
                    value: isCheckedAluno,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedAluno = value!;
                      });
                    },
                  ),
                ),
                const Text(
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
              press: () {
                signUp(emailEditingController.text,
                    passwordEditingController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (!isCheckedAluno && !isCheckedProfessor) {
          Fluttertoast.showToast(msg: "Selecione um tipo de usuário");
          throw FirebaseAuthException(code: "empty-user-type");
        }

        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Email inválido";
            break;
          case "wrong-password":
            errorMessage = "Credenciais inválidas";
            break;
          case "user-not-found":
            errorMessage = "Não existe usuário com este email";
            break;
          case "user-disabled":
            errorMessage = "Usuário desabilitado";
            break;
          case "too-many-requests":
            errorMessage = "Muitas requisições";
            break;
          case "operation-not-allowed":
            errorMessage = "Operação não foi permitida";
            break;
          case "empty-user-type":
            errorMessage = "Selecione um tipo de usuário";
            break;
          default:
            errorMessage = "Um erro ainda indefinido aconteceu";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameEditingController.text;
    if (isCheckedAluno) {
      userModel.isStudent = true;
    }
    if (isCheckedProfessor) {
      userModel.isStudent = false;
    }

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Conta criada com sucesso");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (route) => false);
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
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Text(
        label,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class RegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const RegisterTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.obscureText,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: size.width * 0.75,
      decoration: BoxDecoration(
        color: kGreyColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        autofocus: false,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        scrollPadding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onSaved: (value) {
          controller.text = value!;
        },
        textInputAction: TextInputAction.done,
        validator: validator,
      ),
    );
  }
}
