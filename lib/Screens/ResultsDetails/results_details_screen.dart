import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/body.dart';

class ResultsDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String exameId;
  const ResultsDetailsScreen(
      {Key? key,
      required this.title,
      required this.description,
      required this.exameId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      body: Body(titulo: title, description: description, exameId: exameId),
    );
  }
}
