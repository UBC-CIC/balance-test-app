import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:balance_test/models/PatientListItem.dart';
import 'package:flutter/foundation.dart';
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

  late Future<List<PatientListItem>> patientList;

  //METHODS

  @override
  void initState() {
    super.initState();
    patientList = getPatientList();
  }

  Future<List<PatientListItem>> getPatientList() async {
    try {
      var query = '''
        query MyQuery {
          getPatientsForCareprovider(care_provider_id: "${widget.userID.split(":")[1]}") {
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
    print(response);
      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ${response.errors}');
        }
        return <PatientListItem>[];
      } else {
        final testListJson = json.decode(response.data!);
        List<PatientListItem> patientReturnList = [];
        testListJson["getPatientsForCareprovider"].forEach((entry) {
          patientReturnList.add(PatientListItem.fromJson(entry));
        });
        patientReturnList.sort((a, b) =>
            a.firstName.compareTo(
                b.firstName));
        return patientReturnList;
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }

    return <PatientListItem>[];

  }


 void addPatient() async {
    try {
      var query = '''
            mutation MyMutation2 {
              addPatientToCareProvider(care_provider_id: "8101bca9-ab62-41e0-a376-a58239d4fdb5", patient_id: "0d33fb19-fe7b-4d1b-91f5-60bcfc6d175f") {
                care_provider_id
              }
            }
          ''';

      final response = await Amplify.API
          .query(request: GraphQLRequest<String>(document: query, variables: {'patient_id': widget.userID}))
          .response;

      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ${response.errors}');
        }
      } else {
        if (kDebugMode) {
          print(response.data);
        }
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }
  }


  //UI

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<PatientListItem>>(
        future: patientList,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return AlphabetScrollPage(
              patientList: snapshot.data!,
              parentCtx: widget.parentCtx,
            );
          } else if(snapshot.hasData && snapshot.data!.isEmpty){
            return const Center(child: Text('No Patients Assigned'));
            // return Center(child: ElevatedButton(onPressed: addPatient,
            // child: Icon(Icons.add),));
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
