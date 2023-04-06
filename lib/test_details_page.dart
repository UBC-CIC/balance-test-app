import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TestDetailsPage extends StatefulWidget {
  const TestDetailsPage({
    Key? key,
    required this.testID,
    required this.formattedMovementName,
    required this.movementName,
    required this.dateFormatted,
    required this.score,
    required this.notes,
    required this.dateTimeObj,
    required this.userID,
    required this.duration,
  }) : super(key: key);

  final String testID;
  final String formattedMovementName;
  final String movementName;
  final String dateFormatted;
  final String score;
  final String? notes;
  final DateTime dateTimeObj;
  final String userID;
  final int duration;

  @override
  State<TestDetailsPage> createState() => _TestDetailsPageState();
}

class TimeSeriesData {
  final DateTime time;
  final double value;

  TimeSeriesData(this.time, this.value);
}

class _TestDetailsPageState extends State<TestDetailsPage> {
  //VARIABLES
  final controller = ScrollController();

  late Future<List<charts.Series<TimeSeriesData, DateTime>>> axSeriesList = queryGraphData("ax");
  late Future<List<charts.Series<TimeSeriesData, DateTime>>> aySeriesList = queryGraphData("ay");
  late Future<List<charts.Series<TimeSeriesData, DateTime>>> azSeriesList = queryGraphData("az");
  late Future<List<charts.Series<TimeSeriesData, DateTime>>> gxSeriesList = queryGraphData("gx");
  late Future<List<charts.Series<TimeSeriesData, DateTime>>> gySeriesList = queryGraphData("gy");
  late Future<List<charts.Series<TimeSeriesData, DateTime>>> gzSeriesList = queryGraphData("gz");
  late Future<List<charts.Series<TimeSeriesData, DateTime>>> mxSeriesList = queryGraphData("mx");
  late Future<List<charts.Series<TimeSeriesData, DateTime>>> mySeriesList = queryGraphData("my");
  late Future<List<charts.Series<TimeSeriesData, DateTime>>> mzSeriesList = queryGraphData("mz");

  //METHODS

  Future<List<charts.Series<TimeSeriesData, DateTime>>> queryGraphData(String sensor) async {
    try {
      var query = '''
        query MyQuery {
          getMeasurementData(day: ${widget.dateTimeObj.day}, measurement: $sensor, month: ${widget.dateTimeObj.month}, patient_id: "${widget.userID}", test_event_id: "${widget.testID}", test_type: "${widget.movementName}", year: ${widget.dateTimeObj.year}) {
            ts
            val
          }
        }
      ''';

      final response = await Amplify.API.query(request: GraphQLRequest<String>(document: query, variables: {'patient_id': widget.userID})).response;

      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ${response.errors}');
        }
        return <charts.Series<TimeSeriesData, DateTime>>[];
      } else {
        final sensorDataJson = json.decode(response.data!);

        final List<String> sensorTimestamps = sensorDataJson["getMeasurementData"]["ts"].map<String>((e) => e.toString()).toList();
        final List<double> sensorValues = sensorDataJson["getMeasurementData"]["val"].map<double>((e) => double.parse(e.toString())).toList();

        return createChartSeries(sensorTimestamps, sensorValues);
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }
    return <charts.Series<TimeSeriesData, DateTime>>[];
  }

  List<charts.Series<TimeSeriesData, DateTime>> createChartSeries(List<String> tsList, List<double> sensorList) {
    final data = generateTimeSeriesDataList(tsList, sensorList);

    return [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Sample',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.indigo),
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: data,
      )
    ];
  }

  List<TimeSeriesData> generateTimeSeriesDataList(List<String> tsList, List<double> sensorList) {
    List<TimeSeriesData> data = [];

    for (int i = 0; i < tsList.length; i += 1) {
      DateTime dateTime = DateTime.parse(tsList[i]);
      data.add(TimeSeriesData(dateTime, sensorList[i]));
    }

    return data;
  }

  String formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(1, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xfff2f1f6),
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 0.03 * height,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 0.06 * height,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            'Test Details',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(
                // color: Color.fromRGBO(141, 148, 162, 1.0),
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xfcf2f1f6),
      ),
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              height: 0.12 * height,
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
                                    'Movement',
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
                          Flexible(
                            //Overflow text pushes to next line
                            child: Text(
                              widget.formattedMovementName,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            height: 25,
                            thickness: 1,
                            indent: 5,
                            endIndent: 5,
                            color: Color(0xffcececf),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.calendar,
                                  size: 24,
                                  color: Colors.indigo,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(
                                    'Date and Time',
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
                          Flexible(
                            //Overflow text pushes to next line
                            child: Text(
                              widget.dateFormatted,
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            height: 25,
                            thickness: 1,
                            indent: 5,
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              CupertinoIcons.chart_bar_alt_fill,
                                              size: 24,
                                              color: Colors.indigo,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                              child: Text(
                                                'Score',
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
                                          Text(
                                            widget.score,
                                            style: GoogleFonts.nunito(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 35,
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
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.timer_rounded,
                                              size: 24,
                                              color: Colors.indigo,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                              child: Text(
                                                'Duration',
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
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          formatDuration(widget.duration),
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'sec',
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
            (widget.notes != null && widget.notes!.isNotEmpty)
                ? Padding(
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
                            padding: const EdgeInsets.fromLTRB(22.0, 20, 22.0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.square_list,
                                        size: 24,
                                        color: Colors.indigo,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Text(
                                          'Notes',
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
                                Flexible(
                                  //Overflow text pushes to next line
                                  child: Text(
                                    widget.notes.toString(),
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 20,
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
                  )
                : Container(),
            const Divider(
              height: 22,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.05 * width, 0, 0, 0),
              child: const Text(
                'Test Graphs',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'DMSans-Bold',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 50),
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
                      padding: const EdgeInsets.fromLTRB(22.0, 20, 22.0, 0),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'Accelerometer X',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
                            future: axSeriesList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  width: width * 0.9,
                                  height: 200,
                                  child: const SpinKitThreeInOut(
                                    color: Colors.indigo,
                                    size: 25.0,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final axList = snapshot.data;
                                if (axList!.isEmpty) {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: const Center(
                                      child: Text('Data still processing'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: charts.TimeSeriesChart(
                                      axList,
                                      animate: true,
                                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                                    ),
                                  );
                                }
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            }),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Accelerometer Y',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
                            future: aySeriesList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  width: width * 0.9,
                                  height: 200,
                                  child: const SpinKitThreeInOut(
                                    color: Colors.indigo,
                                    size: 25.0,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final ayList = snapshot.data;
                                if (ayList!.isEmpty) {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: const Center(
                                      child: Text('Data still processing'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: charts.TimeSeriesChart(
                                      ayList,
                                      animate: true,
                                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                                    ),
                                  );
                                }
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            }),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Accelerometer Z',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
                            future: azSeriesList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  width: width * 0.9,
                                  height: 200,
                                  child: const SpinKitThreeInOut(
                                    color: Colors.indigo,
                                    size: 25.0,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final azList = snapshot.data;
                                if (azList!.isEmpty) {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: const Center(
                                      child: Text('Data still processing'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: charts.TimeSeriesChart(
                                      azList,
                                      animate: true,
                                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                                    ),
                                  );
                                }
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            }),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Gyroscope X',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
                            future: gxSeriesList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  width: width * 0.9,
                                  height: 200,
                                  child: const SpinKitThreeInOut(
                                    color: Colors.indigo,
                                    size: 25.0,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final gxList = snapshot.data;
                                if (gxList!.isEmpty) {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: const Center(
                                      child: Text('Data still processing'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: charts.TimeSeriesChart(
                                      gxList,
                                      animate: true,
                                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                                    ),
                                  );
                                }
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            }),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Gyroscope Y',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
                            future: gySeriesList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  width: width * 0.9,
                                  height: 200,
                                  child: const SpinKitThreeInOut(
                                    color: Colors.indigo,
                                    size: 25.0,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final gyList = snapshot.data;
                                if (gyList!.isEmpty) {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: const Center(
                                      child: Text('Data still processing'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: charts.TimeSeriesChart(
                                      gyList,
                                      animate: true,
                                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                                    ),
                                  );
                                }
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            }),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Gyroscope Z',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
                            future: gzSeriesList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  width: width * 0.9,
                                  height: 200,
                                  child: const SpinKitThreeInOut(
                                    color: Colors.indigo,
                                    size: 25.0,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final gzList = snapshot.data;
                                if (gzList!.isEmpty) {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: const Center(
                                      child: Text('Data still processing'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: charts.TimeSeriesChart(
                                      gzList,
                                      animate: true,
                                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                                    ),
                                  );
                                }
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            }),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Magnetometer X',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
                            future: mxSeriesList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  width: width * 0.9,
                                  height: 200,
                                  child: const SpinKitThreeInOut(
                                    color: Colors.indigo,
                                    size: 25.0,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final mxList = snapshot.data;
                                if (mxList!.isEmpty) {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: const Center(
                                      child: Text('Data still processing'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: charts.TimeSeriesChart(
                                      mxList,
                                      animate: true,
                                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                                    ),
                                  );
                                }
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            }),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Magnetometer Y',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
                            future: mySeriesList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  width: width * 0.9,
                                  height: 200,
                                  child: const SpinKitThreeInOut(
                                    color: Colors.indigo,
                                    size: 25.0,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final myList = snapshot.data;
                                if (myList!.isEmpty) {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: const Center(
                                      child: Text('Data still processing'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: charts.TimeSeriesChart(
                                      myList,
                                      animate: true,
                                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                                    ),
                                  );
                                }
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            }),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'Magnetometer Z',
                          style: GoogleFonts.nunito(
                            textStyle: const TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FutureBuilder<List<charts.Series<TimeSeriesData, DateTime>>>(
                            future: mzSeriesList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  width: width * 0.9,
                                  height: 200,
                                  child: const SpinKitThreeInOut(
                                    color: Colors.indigo,
                                    size: 25.0,
                                  ),
                                );
                              } else if (snapshot.hasData) {
                                final mzList = snapshot.data;
                                if (mzList!.isEmpty) {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: const Center(
                                      child: Text('Data still processing'),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    width: width * 0.9,
                                    height: 200,
                                    child: charts.TimeSeriesChart(
                                      mzList,
                                      animate: true,
                                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                                    ),
                                  );
                                }
                              } else {
                                return Text(snapshot.error.toString());
                              }
                            }),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                          color: Colors.transparent,
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
