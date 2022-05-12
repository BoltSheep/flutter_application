import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../model/atlas_model.dart';
import '../atlas_details_screen.dart';

class Body extends StatefulWidget {
  final String categoria;
  final String celula;

  const Body({
    Key? key,
    required this.categoria,
    required this.celula,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String dropdownCategoriaValue = 'Categoria';
  String dropdownCelulaValue = 'Célula';
  List<String> categories = [
    'Categoria',
    'Neutrófilos',
    'Linfócitos',
    'Eosinófilos',
    'Basófilos',
    'Monócitos',
    'Células eritroides',
    'Célula rompida',
  ];

  AtlasModel atlasModel = AtlasModel();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    dropdownCategoriaValue = widget.categoria;
    dropdownCelulaValue = widget.celula;

    return SingleChildScrollView(
      child: Column(children: [
        Container(
          alignment: Alignment.centerLeft,
          child: const Padding(
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
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08, vertical: size.height * 0.01),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: kGreyColor),
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              filled: true,
              fillColor: kGreyColor,
            ),
            dropdownColor: kGreyColor,
            value: dropdownCategoriaValue,
            icon: const Icon(
              Icons.arrow_drop_down_circle,
              color: kPrimaryColor,
              size: 30,
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownCategoriaValue = newValue!;
              });
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('celula')
              .where('categoria', isEqualTo: dropdownCategoriaValue)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String> celulas = ['Célula'];

              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                DocumentSnapshot snap = snapshot.data!.docs[i];
                celulas.add(snap.get('nome'));
              }

              return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                    vertical: size.height * 0.01),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: kGreyColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: kGreyColor,
                  ),
                  dropdownColor: kGreyColor,
                  value: dropdownCelulaValue,
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
                      dropdownCelulaValue = newValue!;
                      if (newValue != "Célula") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AtlasDetailsScreen(
                                  categoria: dropdownCategoriaValue,
                                  celula: dropdownCelulaValue);
                            },
                          ),
                        );
                      }
                    });
                  },
                  items: celulas.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        // Mock images
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('atlas')
              .where('categoria', isEqualTo: dropdownCategoriaValue)
              .where('celula', isEqualTo: dropdownCelulaValue)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<AtlasModel> atlas = [];

              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                DocumentSnapshot snap = snapshot.data!.docs[i];
                atlasModel.abreviatura = snap.get('abreviatura');
                atlasModel.categoria = snap.get('categoria');
                atlasModel.celula = snap.get('celula');
                atlasModel.imagem = snap.get('imagem');

                atlas.add(atlasModel);
              }

              return Column(
                children: [
                  SizedBox(
                    height: 500,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: atlas.length,
                        itemBuilder: (context, index) {
                          return InteractiveViewer(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    atlas[index].imagem!,
                                  )),
                            ),
                          );
                        }),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ]),
    );
  }
}
