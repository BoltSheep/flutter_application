import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:intl/intl.dart';

import '../../ResultsDetails/results_details_screen.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  getDate(Timestamp exameDate) {
    DateTime date = DateTime.parse(exameDate.toDate().toString());

    return DateFormat('dd-MM-yyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                'Resultados',
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
            color: kBlueLightColor,
            width: size.width * 0.85,
            height: size.height * 0.05,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.05),
                  child: const Text(
                    'Exame',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.37),
                  child: const Text(
                    'Data',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('exames').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map> exames = [];

                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  DocumentSnapshot snap = snapshot.data!.docs[i];
                  exames.add({
                    'id': snap.id,
                    'title': snap.get('title'),
                    'description': snap.get('description'),
                    'createdAt': snap.get('createdAt'),
                  });
                }

                return Wrap(
                  children: exames.map((exame) {
                    return Container(
                      color: kGreyColor,
                      width: size.width * 0.85,
                      height: size.height * 0.05,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: size.width * 0.05),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ResultsDetailsScreen(
                                      title: exame['title'],
                                      description: exame['description'],
                                      exameId: exame['id'],
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(
                              exame['title'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: size.width * 0.30),
                            child: Text(
                              getDate(exame['createdAt']),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
