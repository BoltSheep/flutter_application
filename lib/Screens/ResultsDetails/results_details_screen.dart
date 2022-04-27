import 'package:flutter/material.dart';

import 'components/body.dart';

class ResultsDetailsScreen extends StatelessWidget {
  const ResultsDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(titulo: "Título Teste"),
    );
  }
}
