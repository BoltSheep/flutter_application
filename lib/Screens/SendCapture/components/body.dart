import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_application/constants.dart';
import 'package:flutter_application/model/exame_images_model.dart';
import 'package:flutter_application/model/exames_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/rounded_button.dart';
import '../../Register/components/body.dart';
import '../send_capture_screen.dart';

class Body extends StatefulWidget {
  final File image;

  const Body({Key? key, required this.image}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final tituloEditingController = TextEditingController();
  final descricaoEditingController = TextEditingController();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final List<Map> availableTags = [
    {'name': 'Em andamento'},
    {'name': 'Novo exame'},
  ];
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  bool firstPress = true;

  File? image;
  String dropdownExameValue = 'Exame';
  Object? _value = false;

  Future<String> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'exames/img-${DateTime.now().toString()}.jpg';
      await storage.ref(ref).putFile(file);
      return ref;
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload da imagem: ${e.code}');
    }
  }

  Future<String> uploadImage(File file) async {
    String ref = await upload(file.path);

    Reference refinha = storage.ref(ref);
    return await refinha.getDownloadURL();
  }

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

  Future createExame(
      {required String title,
      required String description,
      required String url,
      required String userUid}) async {
    final docExame = FirebaseFirestore.instance.collection('exames').doc();
    final docImage =
        FirebaseFirestore.instance.collection('exame_images').doc();

    final exame = ExamesModel(
      id: docExame.id,
      title: title,
      description: description,
      userUid: userUid,
      createdAt: DateTime.now(),
    );

    final exameImages = ExameImagesModel(
      id: docImage.id,
      exameId: docExame.id,
      url: url,
      createdAt: DateTime.now(),
    );

    final exameMap = exame.toMap();
    final exameImagesMap = exameImages.toMap();

    await docExame.set(exameMap);
    await docImage.set(exameImagesMap);
  }

  createExameImages({required String url, required String exameId}) async {
    final docImage =
        FirebaseFirestore.instance.collection('exame_images').doc();

    final exameImages = ExameImagesModel(
      id: docImage.id,
      exameId: exameId,
      url: url,
      createdAt: DateTime.now(),
    );

    final exameImagesMap = exameImages.toMap();

    await docImage.set(exameImagesMap);
  }

  getExameId({required String title}) async {
    final docExame = await FirebaseFirestore.instance
        .collection('exames')
        .where('title', isEqualTo: title)
        .get()
        .then((snapshot) => snapshot.docs.first.id);

    return docExame;
  }

  void enviarNovoExame() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (firstPress) {
          firstPress = false;
          final String url = await uploadImage(widget.image);
          final title = tituloEditingController.text;
          final description = descricaoEditingController.text;
          User? user = FirebaseAuth.instance.currentUser;
          String userUid = "";
          if (user != null) {
            userUid = user.uid;
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const WelcomeScreen();
              },
            ));
          }

          createExame(
            title: title,
            description: description,
            url: url,
            userUid: userUid,
          );

          pickImage();
        }
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          default:
            errorMessage = "Um erro ainda indefinido aconteceu";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  void enviarExame() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (firstPress && dropdownExameValue != 'Exame') {
          firstPress = false;
          final String url = await uploadImage(widget.image);
          final exameId = await getExameId(title: dropdownExameValue);

          createExameImages(url: url, exameId: exameId);

          pickImage();
        }
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          default:
            errorMessage = "Um erro ainda indefinido aconteceu";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> exames = [];

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                'Enviar Captura',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08, vertical: size.height * 0.01),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.4,
                  child: Image.file(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Column(children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.08),
                  child: Radio(
                    value: 'Em andamento',
                    groupValue: _value,
                    onChanged: (value) {
                      setState(() {
                        _value = value!;
                      });
                    },
                  ),
                ),
                const Text(
                  'Em andamento',
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
                  padding: EdgeInsets.only(left: size.width * 0.08),
                  child: Radio(
                    value: 'Novo exame',
                    groupValue: _value,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ),
                const Text(
                  'Novo exame',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ]),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('exames').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                exames = [];
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  DocumentSnapshot snap = snapshot.data!.docs[i];
                  exames.add(snap.get('title'));
                }
                return Container();
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Wrap(
            children: availableTags.map((tag) {
              if (tag['name'] == 'Novo exame' && _value == tag['name']) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const RegisterLabels(label: 'Título:'),
                      RegisterTextField(
                        controller: tituloEditingController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{3,11}$');
                          if (value!.isEmpty) {
                            return ("Titulo não pode ser vazio");
                          }
                          if ([...exames].any((element) => element == value)) {
                            return ("Titulo já existe");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Utilize um titulo válido(Min. 3 e Max. 11 Caracteres)");
                          }
                          return null;
                        },
                      ),
                      const RegisterLabels(label: 'Descrição:'),
                      RegisterTextField(
                        controller: descricaoEditingController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("Descrição não pode ser vazio");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Utilize uma descrição válido(Min. 3 Caracteres)");
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.03),
                        child: RoundedButton(
                          text: "Enviar",
                          color: kPrimaryColor,
                          press: () async {
                            enviarNovoExame();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (tag['name'] == 'Em andamento' && _value == tag['name']) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('exames')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<String> exames = ['Exame'];

                            for (int i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              DocumentSnapshot snap = snapshot.data!.docs[i];
                              exames.add(snap.get('title'));
                            }

                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.08,
                                  vertical: size.height * 0.01),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: kGreyColor),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  filled: true,
                                  fillColor: kGreyColor,
                                ),
                                dropdownColor: kGreyColor,
                                value: dropdownExameValue,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: kPrimaryColor,
                                  size: 30,
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownExameValue = newValue!;
                                  });
                                },
                                items: exames.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong'));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.03),
                        child: RoundedButton(
                          text: "Enviar",
                          color: kPrimaryColor,
                          press: () async {
                            enviarExame();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container();
            }).toList(),
          ),
        ],
      ),
    );
  }
}
