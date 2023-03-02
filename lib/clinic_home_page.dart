import 'package:balance_test/TestDetailsListItem.dart';
import 'package:balance_test/test_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

import 'PatientListItem.dart';
import 'alphabet_scroll_page.dart';


class ClinicHomePage extends StatefulWidget {
  const ClinicHomePage({Key? key, required this.parentCtx, required this.userID}) : super(key: key);

  final BuildContext parentCtx;
  final String userID;

  @override
  State<ClinicHomePage> createState() => _ClinicHomePageState();
}

class _ClinicHomePageState extends State<ClinicHomePage> {
  //VARIABLES

  final controller = ScrollController();

  List<PatientListItem> patientList = getTests();

  static List<PatientListItem> getTests() {
    const data = [
      {
        "name": "John Doe",
        "email": "johndoe@gmail.com",
        "userID": "58a0a821",
      },
      {
        "name": "Jane Doe",
        "email": "janedoe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Robbie Mac",
        "email": "robbiemac@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Amanda Spence",
        "email": "amandaspence@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Palmer Mills",
        "email": "palmermils@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Sidney Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Caleb Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Derek Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Edward Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Frank Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Gabe Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Harry Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Isaiah Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "James Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Kelly Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Larry Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Max Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Nolan Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Oswald Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "Larry Monroe",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },
      {
        "name": "d",
        "email": "sidneymonroe@gmail.com",
        "userID": "58a0a821-7529-4bd9-8838-1ba8a00c557d",
      },

    ];

    List<PatientListItem> patientList = data.map<PatientListItem>(PatientListItem.fromJson).toList();
    patientList.sort((a, b) => a.name.compareTo(b.name));
    return patientList;
  }


  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    return Expanded(child: AlphabetScrollPage(patientList: patientList, parentCtx: widget.parentCtx,));

  }

}
