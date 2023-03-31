import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:balance_test/models/PatientCustomListItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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


  late Future<List<PatientCustomListItem>> futurePatientList;

  @override
  void initState() {
    super.initState();
    futurePatientList = getPatientList();
  }


  Future<List<PatientCustomListItem>> getPatientList() async {

    try {
      var query = '''
        query MyQuery {
          getPatientsForCareprovider(care_provider_id: "${widget.userID}") {
            email
            first_name
            last_name
            patient_id
          }
        }
      ''';
      print(query);

      final response = await Amplify.API
          .query(request: GraphQLRequest<String>(document: query, variables: {'patient_id': widget.userID}))
          .response;

      if (response.data == null) {
        print('errors: ${response.errors}');
        return <PatientCustomListItem>[];
      } else {
        final testListJson = json.decode(response.data!);

        List<PatientCustomListItem> tempList = [];

        testListJson["getPatientsForCareprovider"].forEach((entry) {
          tempList.add(PatientCustomListItem.fromJson(entry));
        });

        tempList.sort((a, b) =>
            a.firstName.compareTo(
                b.firstName));
        return tempList;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
    }

    return <PatientCustomListItem>[];

  }


  //UI

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<PatientCustomListItem>>(
        future: futurePatientList,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return AlphabetScrollPage(
              patientList: snapshot.data!,
              parentCtx: widget.parentCtx,
            );
          } else if(snapshot.hasData && snapshot.data!.isEmpty){
            return const Center(child: Text('No Patients Assigned'));
          } else {
            return const Center(
                child: SpinKitThreeInOut(
              color: Colors.indigo,
              size: 50.0,
            ));
          }
        },
      ),
    );
  }
}
