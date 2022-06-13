import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../ResultsDetails/results_details_screen.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  getDate(Timestamp exameDate) {
    DateTime date = DateTime.parse(exameDate.toDate().toString());

    return DateFormat('dd-MM-yyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('exames')
                .where('userUid', isEqualTo: user!.uid)
                .snapshots(),
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

                return DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Exame',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Data',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                  rows: exames
                      .map(
                        ((exame) => DataRow(
                              cells: <DataCell>[
                                DataCell(
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
                                        color: kBlueColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    getDate(exame['createdAt']),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )
                      .toList(),
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
