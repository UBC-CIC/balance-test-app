import 'dart:convert';
import 'dart:core';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:balance_test/test_instructions_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gaimon/gaimon.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balance_test/models/Test.dart';

class NewTestPageClinic extends StatefulWidget {
  const NewTestPageClinic({Key? key, required this.parentCtx, required this.userID}) : super(key: key);

  final BuildContext parentCtx;
  final String userID;

  @override
  State<NewTestPageClinic> createState() => _NewTestPageClinicState();
}

class _NewTestPageClinicState extends State<NewTestPageClinic> {
  //VARIABLES

  //Controller for fading scroll view

  late Future<List<Test>> futureTestList;

  static List<Test> testList = [];

  Future<List<Test>> queryTests() async {
    print(widget.userID);
    try {
      var query = '''
        query MyQuery {
          getAllAvailableTests {
            duration_in_seconds
            instructions
            test_type
          }
        }
      ''';

      final response = await Amplify.API
          .query(request: GraphQLRequest<String>(document: query))
          .response;

      if (response.data == null) {
        print('errors: ${response.errors}');
        return <Test>[];
      } else {
        final testListJson = json.decode(response.data!);

        List<Test> tempList = [];

        testListJson["getAllAvailableTests"].forEach((entry) {
          tempList.add(Test.fromJson(entry));
        });

        tempList.sort((a, b) =>
            convertMovementName(b!.test_type!).compareTo(
                convertMovementName(a!.test_type!)));
        return tempList;
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return <Test>[];
  }

  @override
  void initState() {
    super.initState();
    futureTestList = queryTests();
  }


  static String convertMovementName(String movement) {
    if (movement == 'sit-to-stand') {
      return 'Sit to Stand';
    } else if (movement == 'stand-unsupported') {
      return 'Stand\nUnsupported';
    } else if (movement == 'sit-back-unsupported') {
      return 'Sit with Back\nUnsupported';
    } else if (movement == 'stand-to-sit') {
      return 'Stand to Sit';
    } else if (movement == 'transfers') {
      return 'Transfers';
    } else if (movement == 'stand-eyes-closed') {
      return 'Stand with\nEyes Closed';
    } else if (movement == 'stand-feet-together') {
      return 'Stand with\nFeet Together';
    } else if (movement == 'stand-reaching-forward') {
      return 'Stand while\nReaching Forward';
    } else if (movement == 'pick-up-object') {
      return 'Pick Up\nObject';
    } else if (movement == 'look-behind-shoulders') {
      return 'Look Behind\nShoulders';
    } else if (movement == '360-turn') {
      return 'Turn\n360 Degrees';
    } else if (movement == 'alternate-foot') {
      return 'Alternate Foot\nOn Step or Stool';
    } else if (movement == 'one-foot-in-front') {
      return 'Stand with\nOne Foot In Front';
    } else if (movement == 'stand-one-leg') {
      return 'Stand with\nOne Leg';
    } else {
      return 'Unknown';
    }
  }


  String formatDuration(int totalSeconds) {
    if (totalSeconds > 59) {
      int minutes = (totalSeconds / 60).round();
      String mintueFormat;
      if (minutes == 1) {
        mintueFormat = 'minute';
      } else {
        mintueFormat = 'minutes';
      }
      return '$minutes $mintueFormat';
    } else {
      return '$totalSeconds seconds';
    }
  }


  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    Widget buildTestList(List<Test> tests) {
      if (tests.isEmpty) {
        return const Center(child: Text('No Assigned Tests'));
      } else {
        return ListView.builder(
            itemCount: tests.length + 1, // To include dropdown as 1st element
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0.05 * width, 15, 0, 0),
                  child: Text(
                    'Tests To Do',
                    style: TextStyle(
                      // color: Color.fromRGBO(141, 148, 162, 1.0),
                      color: Colors.black,
                      fontFamily: 'DMSans-Medium',
                      fontWeight: FontWeight.w900,
                      fontSize: 0.052 * width,
                    ),
                  ),
                );
              } else {
                final test = tests[index - 1];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                  child: Center(
                    child: Card(
                      color: const Color(0xffffffff),
                      elevation: 2,
                      shadowColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: SizedBox(
                        width: width * 0.90,
                        height: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 15, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 70,
                                    width: 0.5 * width,
                                    child: FittedBox(
                                      alignment: Alignment.centerLeft,
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        // 'Sitting with\nBack Unsupported\nFeet Supported',
                                        convertMovementName(test.test_type),
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                            color: Color(0xff2A2A2A),
                                            // fontFamily: 'DMSans-Bold',
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded,
                                          color: Color(0xff006CC6),
                                          size: 20,
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                          child: Text(
                                            formatDuration(
                                                test.duration_in_seconds!),
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                color: Color(0xff006CC6),
                                                fontFamily: 'DMSans-Medium',
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child:
                                SizedBox(
                                  height: 55,
                                  width: 0.26 * width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Gaimon.selection();
                                      Navigator.push(
                                          widget.parentCtx,
                                          //Used to pop to main page instead of home
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TestInstructionsPage(
                                                    movementType: test
                                                        .test_type,
                                                    userID: widget.userID,
                                                    formattedMovementType: convertMovementName(
                                                        test.test_type),
                                                    instructions: test
                                                        .instructions!,
                                                    isClinicApp: false,
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: const Color(
                                            0xff006CC6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              30),
                                          //border radius equal to or more than 50% of width
                                        )),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 3, 0),
                                            child: Text(
                                              'Start',
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'DMSans-Medium',
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            CupertinoIcons.chevron_right,
                                            size: 20,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            });
      }
    }

    return Expanded(
        child: FutureBuilder<List<Test>>(
          future: futureTestList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              testList = snapshot.data!;

              return buildTestList(testList);
            } else {
              return const Center(child: SpinKitThreeInOut(
                color: Colors.indigo,
                size: 50.0,
              ));
            }
          },
        ));
  }
}