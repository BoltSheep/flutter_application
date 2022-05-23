import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  final String titulo;
  final String description;
  final String exameId;
  const Body(
      {Key? key,
      required this.titulo,
      required this.description,
      required this.exameId})
      : super(key: key);

  Widget buildImage(String urlImage, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        color: Colors.grey,
        child: InteractiveViewer(
          child: Image.network(
            urlImage,
            fit: BoxFit.cover,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                titulo,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('exame_images')
                .where('exameId', isEqualTo: exameId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map> exameImages = [];

                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  DocumentSnapshot snap = snapshot.data!.docs[i];
                  exameImages.add({
                    'id': snap.id,
                    'url': snap.get('url'),
                    'exameId': snap.get('exameId'),
                    'createdAt': snap.get('createdAt'),
                  });
                }

                return CarouselSlider.builder(
                  options: CarouselOptions(
                    height: size.height * 0.5,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                  ),
                  itemCount: exameImages.length,
                  itemBuilder: (context, index, realIndex) {
                    final urlImage = exameImages[index]['url'];

                    return buildImage(urlImage, index);
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
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
            child: Text(description),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
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
            child: const Text("Estamos trabalhando."),
          )
        ],
      ),
    );
  }
}
