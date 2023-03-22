import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key, required this.parentCtx, required this.userID})
      : super(key: key);

  final BuildContext parentCtx;
  final String userID;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  //VARIABLES

  // late Future<List<Test>> futureTestList;
  //
  // static List<Test> testList = [];
  //
  // Future<List<Test>> queryTests() async {
  //   print(widget.userID);
  //   try {
  //     var query = '''
  //       query MyQuery {
  //         getAllAvailableTests {
  //           duration_in_seconds
  //           instructions
  //           test_type
  //         }
  //       }
  //     ''';
  //
  //     final response = await Amplify.API
  //         .query(request: GraphQLRequest<String>(document: query))
  //         .response;
  //
  //     if (response.data == null) {
  //       print('errors: ${response.errors}');
  //       return <Test>[];
  //     } else {
  //       final testListJson = json.decode(response.data!);
  //
  //       List<Test> tempList = [];
  //
  //       testListJson["getAllAvailableTests"].forEach((entry) {
  //         tempList.add(Test.fromJson(entry));
  //       });
  //
  //       tempList.sort((a, b) =>
  //           convertMovementName(b!.test_type!).compareTo(
  //               convertMovementName(a!.test_type!)));
  //       return tempList;
  //     }
  //   } on ApiException catch (e) {
  //     print('Query failed: $e');
  //   }
  //   return <Test>[];
  // }

  @override
  void initState() {
    super.initState();
    // futureTestList = queryTests();
  }

  String formatDateTimeDatabase(DateTime dateTime) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String outputTimeString = outputFormat.format(dateTime);
    final duration = dateTime.timeZoneOffset, hours = duration.inHours;
    return "$outputTimeString${hours > 0 ? '+' : '-'}${twoDigits(hours.abs())}";
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Widget buildAnalyticsPage() {
      return Expanded(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Divider(
              height: 0.02 * height,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Center(
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  shadowColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: width * 0.9,
                    height: null,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22.0, 15, 22.0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.accessibility_new_rounded,
                                  size: 24,
                                  color: Colors.indigo,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(
                                    'Balance Score Average',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 6),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 5, 0),
                                              child: Text(
                                                'Week Average',
                                                style: GoogleFonts.nunito(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xff777586),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '78',
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '%',
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                color: Color(0xff777586),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                              child: Text(
                                                'Month Average',
                                                style: GoogleFonts.nunito(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xff777586),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '66',
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '%',
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Color(0xff777586),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          const Divider(
                            height: 25,
                            thickness: 1,
                            indent: 0,
                            endIndent: 5,
                            color: Color(0xffcececf),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 6, 0, 8),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.graph_square,
                                  size: 24,
                                  color: Colors.indigo,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(
                                    'Balance Score Range',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 6),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 5, 0),
                                              child: Text(
                                                'Week Range',
                                                style: GoogleFonts.nunito(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xff777586),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '78',
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '%',
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                color: Color(0xff777586),
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                              child: Text(
                                                'Month Range',
                                                style: GoogleFonts.nunito(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xff777586),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '66',
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '%',
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Color(0xff777586),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          const Divider(
                            height: 15,
                            thickness: 1,
                            indent: 5,
                            endIndent: 5,
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.05 * width, 20, 0, 0),
              child: const Text(
                'Movement Analytics',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'DMSans-Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Gaimon.selection();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: Center(
                  child: Card(
                    color: const Color(0xffffffff),
                    elevation: 2,
                    shadowColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SizedBox(
                      width: width * 0.90,
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(0.06 * width, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 0.46 * width,
                                  height: 55,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Sit to Stand',
                                      style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                          color: Color(0xff2A2A2A),
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: SizedBox(
                              height: 0.13 * width,
                              width: 0.13 * width,
                              child: Icon(
                                CupertinoIcons.forward,
                                color: const Color(0xffc4c4c6),
                                size: 0.06 * width,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 22,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.transparent,
            ),
          ])));
    }

    return buildAnalyticsPage();
  }
}
