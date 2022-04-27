import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import '../Screens/AtlasDetails/atlas_details_screen.dart';

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({Key? key}) : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String dropdownValue = 'Selecione';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.08, vertical: size.height * 0.01),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kGreyColor),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: kGreyColor,
        ),
        dropdownColor: kGreyColor,
        value: dropdownValue,
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
            dropdownValue = newValue!;
            if (newValue != "Selecione") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AtlasDetailsScreen();
                  },
                ),
              );
            }
          });
        },
        items: <String>['Selecione', 'Leucócitos', 'Two', 'Free', 'Four']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
