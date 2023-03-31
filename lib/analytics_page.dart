import 'dart:convert';
import 'dart:core';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:balance_test/sit_to_stand_analytics_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key, required this.parentCtx, required this.userID}) : super(key: key);

  final BuildContext parentCtx;
  final String userID;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  //VARIABLES

  late Future<double?> weekAverage;
  late Future<double?> monthAverage;
  late Future<double?> previousWeekAverage;
  late Future<double?> previousMonthAverage;

  //METHODS

  @override
  void initState() {
    super.initState();

    DateTime currentTime = DateTime.now();

    DateTime oneWeekAgo = currentTime.subtract(const Duration(days: 7));
    DateTime twoWeekAgo = currentTime.subtract(const Duration(days: 14));
    DateTime oneMonthAgo =
        DateTime(currentTime.year, currentTime.month - 1, currentTime.day, currentTime.hour, currentTime.minute, currentTime.second);
    DateTime twoMonthAgo =
        DateTime(currentTime.year, currentTime.month - 2, currentTime.day, currentTime.hour, currentTime.minute, currentTime.second);

    weekAverage = queryAverages(oneWeekAgo, currentTime);
    monthAverage = queryAverages(oneMonthAgo, currentTime);
    previousWeekAverage = queryAverages(twoWeekAgo, oneWeekAgo);
    previousMonthAverage = queryAverages(twoMonthAgo, oneMonthAgo);
  }

  Future<double?> queryAverages(DateTime start, DateTime end) async {
    String startTime = formatDateTimeDatabase(start);
    String endTime = formatDateTimeDatabase(end);
    try {
      var query = '''
        query MyQuery {
          getScoreStatsOverTime(from_time: "$startTime", patient_id: "${widget.userID}", stat: avg, to_time: "$endTime")
        }
      ''';

      final response = await Amplify.API.query(request: GraphQLRequest<String>(document: query, variables: {'patient_id': widget.userID})).response;

      if (response.data == null) {
        print('errors: ${response.errors}');
        return null;
      } else {
        String score = json.decode(response.data!)["getScoreStatsOverTime"];
        return double.parse(score);
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    return null;
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

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

      return Expanded(
          child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Text(
                                'Balance Score Averages',
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
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
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
                                    FutureBuilder<double?>(
                                      future: weekAverage,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Row(
                                            children: [
                                              Text(
                                                snapshot.data!=null? snapshot.data!.round().toString() : '',
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
                                          );
                                        } else {
                                          return Container(height: 44); // loading
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        FutureBuilder<List<double?>>(
                                            future: Future.wait([previousWeekAverage, weekAverage]),
                                            builder: (BuildContext context, AsyncSnapshot<List<double?>> snapshot) {
                                              if (snapshot.hasData) {
                                                // Once all futures are complete, calculate your result here
                                                if (snapshot.data != null && snapshot.data![0] != null && snapshot.data![1] != null) {
                                                  int percent = ((snapshot.data![1]! / snapshot.data![0]!) * 100 - 100).round();
                                                  if (percent < 0) {
                                                    return Text('Down ${percent.toString()}% \nfrom last week',
                                                        style: GoogleFonts.nunito(
                                                          textStyle: const TextStyle(
                                                            color: Colors.redAccent,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ));
                                                  } else {
                                                    return Text('Up ${percent.toString()}% \nfrom last week',
                                                        style: GoogleFonts.nunito(
                                                          textStyle: const TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ));
                                                  }
                                                } else {
                                                  return Text('-',
                                                      style: GoogleFonts.nunito(
                                                      textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                  )));
                                                }
                                              } else {
                                                return Text('',
                                                    style: GoogleFonts.nunito(
                                                        textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        )));
                                              }
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                      const Divider(
                        height: 25,
                        thickness: 0.5,
                        indent: 0,
                        endIndent: 5,
                        color: Color(0xffcececf),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
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
                                    FutureBuilder<double?>(
                                      future: monthAverage,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Row(
                                            children: [
                                              Text(
                                                snapshot.data!=null? snapshot.data!.round().toString() : '-',
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
                                          );
                                        } else {
                                          return Container(
                                            height: 44,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        FutureBuilder<List<double?>>(
                                            future: Future.wait([previousMonthAverage, monthAverage]),
                                            builder: (BuildContext context, AsyncSnapshot<List<double?>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                // Once all futures are complete, calculate your result here
                                                if (snapshot.data != null && snapshot.data![0] != null && snapshot.data![1] != null) {
                                                  int percent = ((snapshot.data![1]! / snapshot.data![0]!) * 100 - 100).round();
                                                  if (percent < 0) {
                                                    return Text('Down ${percent.toString()}% \nfrom last month',
                                                        style: GoogleFonts.nunito(
                                                          textStyle: const TextStyle(
                                                            color: Colors.redAccent,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ));
                                                  } else {
                                                    return Text('Up ${percent.toString()}% \nfrom last month',
                                                        style: GoogleFonts.nunito(
                                                          textStyle: const TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ));
                                                  }
                                                } else {
                                                  return Text('-',
                                                      style: GoogleFonts.nunito(
                                                          textStyle: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                          )));
                                                }
                                              } else {
                                                return Text('',
                                                    style: GoogleFonts.nunito(
                                                        textStyle: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        )));
                                              }
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
            Navigator.push(
                widget.parentCtx,
                //Used to pop to main page instead of home
                MaterialPageRoute(builder: (context) => SitToStandAnalyticsPage(userID: widget.userID)));
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
                        padding: EdgeInsets.fromLTRB(0.06 * width, 0, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 0.46 * width,
                              height: 60,
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

}
