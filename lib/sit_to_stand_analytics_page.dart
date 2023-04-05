import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'models/TestEvent.dart';

class SitToStandAnalyticsPage extends StatefulWidget {
  const SitToStandAnalyticsPage({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  State<SitToStandAnalyticsPage> createState() => _SitToStandAnalyticsPageState();
}

class TimeSeriesScoreData {
  final DateTime time;
  final int value;

  TimeSeriesScoreData(this.time, this.value);
}

class TimeSeriesRangeData {
  final DateTime time;
  final double value;

  TimeSeriesRangeData(this.time, this.value);

}

class _SitToStandAnalyticsPageState extends State<SitToStandAnalyticsPage> {
  ///SCORE GRAPH CODE
  //VARIABLES
  late Future<List<charts.Series<TimeSeriesScoreData, DateTime>>> scoreSeriesList =
      querySitToStandScores();

  //METHODS

  Future<List<charts.Series<TimeSeriesScoreData, DateTime>>> querySitToStandScores() async {
    try {
      var query = '''
        query MyQuery {
          getTestEvents(patient_id: "${widget.userID}", test_type: "sit-to-stand") {
            balance_score
            start_time          
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
        return <charts.Series<TimeSeriesScoreData, DateTime>>[];
      } else {

        final  scoreValueJson = json.decode(response.data!);


        List<TestEvent> tempList = [];

        scoreValueJson["getTestEvents"].forEach((entry) {
          tempList.add(TestEvent.fromJson(entry));
        });

        tempList.sort((a, b) => b.start_time!.compareTo(a.start_time!));


        final List<DateTime> scoreTimeStamps = [];
        final List<int> scoreValues = [];
        for (var element in tempList) {
          if(element.start_time!=null && element.balance_score!=null) {
            scoreTimeStamps.add(element.start_time!.getDateTimeInUtc());
            scoreValues.add(element.balance_score!);
          }
        }
        return createChartSeries(scoreTimeStamps, scoreValues);
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }
    return <charts.Series<TimeSeriesScoreData, DateTime>>[];
  }


  List<charts.Series<TimeSeriesScoreData, DateTime>> createChartSeries(
      List<DateTime> tsList, List<int> scoreList) {
    final data = generateTimeSeriesDataList(tsList, scoreList);
    return [
      charts.Series<TimeSeriesScoreData, DateTime>(
        id: 'Sample',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.indigo),
        domainFn: (TimeSeriesScoreData data, _) => data.time,
        measureFn: (TimeSeriesScoreData data, _) => data.value,
        data: data,
      )
    ];
  }

  List<TimeSeriesScoreData> generateTimeSeriesDataList(
      List<DateTime> tsList, List<int> scoreList) {
    List<TimeSeriesScoreData> data = [];
    for (int i = 0; i < tsList.length; i += 1) {
      data.add(TimeSeriesScoreData(tsList[i], scoreList[i]));
    }
    return data;
  }

  ///RANGE GRAPHS CODE
  //VARIABLES

  late Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> rangeSeriesListAx =
  querySitToStandRange("ax");

  late Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> rangeSeriesListAy =
  querySitToStandRange("ay");

  late Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> rangeSeriesListAz =
  querySitToStandRange("az");

  late Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> rangeSeriesListGx =
  querySitToStandRange("gx");

  late Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> rangeSeriesListGy =
  querySitToStandRange("gy");

  late Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> rangeSeriesListGz =
  querySitToStandRange("gz");

  late Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> rangeSeriesListMx =
  querySitToStandRange("mx");

  late Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> rangeSeriesListMy =
  querySitToStandRange("my");

  late Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> rangeSeriesListMz =
  querySitToStandRange("mz");

  //METHODS

  Future<List<charts.Series<TimeSeriesRangeData, DateTime>>> querySitToStandRange(String sensor) async {

    try {
      var query = '''
        query MyQuery {
          getMeasurementRange(measurement: $sensor, patient_id: "${widget.userID}") {
            day
            month
            year
            max
            min
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
        return <charts.Series<TimeSeriesRangeData, DateTime>>[];
      } else {
        final  rangeDataJson = json.decode(response.data!);
        List<double> minList = rangeDataJson["getMeasurementRange"]['min'].map<double>((e) => double.parse(e.toString()))
            .toList();
        List<double> maxList = rangeDataJson["getMeasurementRange"]['max'].map<double>((e) => double.parse(e.toString()))
            .toList();
        List<int> dayList = rangeDataJson["getMeasurementRange"]['day'].map<int>((e) => int.parse(e.toString()))
            .toList();
        List<int> monthList = rangeDataJson["getMeasurementRange"]['month'].map<int>((e) => int.parse(e.toString()))
            .toList();
        List<int> yearList = rangeDataJson["getMeasurementRange"]['year'].map<int>((e) => int.parse(e.toString()))
            .toList();
        List<DateTime> dateList = [];
        for(int i=0; i<dayList.length;i++){
          int day = dayList[i];
          int month = monthList[i];
          int year = yearList[i];
          DateTime dateTime = DateTime(year, month, day);
          dateList.add(dateTime);
        }

        return createRangeChartSeries(dateList, minList, maxList);
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }
    return <charts.Series<TimeSeriesRangeData, DateTime>>[];
  }


  List<charts.Series<TimeSeriesRangeData, DateTime>> createRangeChartSeries(
      List<DateTime> tsList, List<double> minList, List<double> maxList) {
    final minData = generateTimeSeriesRangeDataList(tsList, minList);
    final maxData = generateTimeSeriesRangeDataList(tsList, maxList);

    return [

      charts.Series<TimeSeriesRangeData, DateTime>(
        id: 'Max',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.indigo),
        domainFn: (TimeSeriesRangeData data, _) => data.time,
        measureFn: (TimeSeriesRangeData data, _) => data.value,
        data: maxData,
      ),

      charts.Series<TimeSeriesRangeData, DateTime>(
        id: 'Min',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.indigo),
        domainFn: (TimeSeriesRangeData data, _) => data.time,
        measureFn: (TimeSeriesRangeData data, _) => data.value,
        data: minData,
      ),
    ];
  }

  List<TimeSeriesRangeData> generateTimeSeriesRangeDataList(
      List<DateTime> tsList, List<double> valueList) {
    List<TimeSeriesRangeData> data = [];
    for (int i = 0; i < tsList.length; i += 1) {
      data.add(TimeSeriesRangeData(tsList[i], valueList[i]));
    }
    return data;
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
              'Sit to Stand',
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                            padding:
                                const EdgeInsets.fromLTRB(22.0, 20, 22.0, 0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sit to Stand Score',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  FutureBuilder<
                                          List<
                                              charts.Series<TimeSeriesScoreData,
                                                  DateTime>>>(
                                      future: scoreSeriesList,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.05 * width, 10, 0, 0),
                    child: const Text(
                      'Sensor Range Graphs',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'DMSans-Bold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
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
                            padding:
                            const EdgeInsets.fromLTRB(22.0, 20, 22.0, 0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  FutureBuilder<
                                      List<
                                          charts.Series<TimeSeriesRangeData,
                                              DateTime>>>(
                                      future: rangeSeriesListAx,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                defaultRenderer: charts.BarRendererConfig<DateTime>(
                                                    groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 0.0, maxBarWidthPx: 3, cornerStrategy: const charts.ConstCornerStrategy(4),),

                                                defaultInteractions: false,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
                                  FutureBuilder<
                                      List<
                                          charts.Series<TimeSeriesRangeData,
                                              DateTime>>>(
                                      future: rangeSeriesListAy,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                defaultRenderer: charts.BarRendererConfig<DateTime>(
                                                  groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 0.0, maxBarWidthPx: 3, cornerStrategy: const charts.ConstCornerStrategy(4),),

                                                defaultInteractions: false,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
                                  FutureBuilder<
                                      List<
                                          charts.Series<TimeSeriesRangeData,
                                              DateTime>>>(
                                      future: rangeSeriesListAz,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                defaultRenderer: charts.BarRendererConfig<DateTime>(
                                                  groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 0.0, maxBarWidthPx: 3, cornerStrategy: const charts.ConstCornerStrategy(4),),

                                                defaultInteractions: false,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
                                  FutureBuilder<
                                      List<
                                          charts.Series<TimeSeriesRangeData,
                                              DateTime>>>(
                                      future: rangeSeriesListGx,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                defaultRenderer: charts.BarRendererConfig<DateTime>(
                                                  groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 0.0, maxBarWidthPx: 3, cornerStrategy: const charts.ConstCornerStrategy(4),),

                                                defaultInteractions: false,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
                                  FutureBuilder<
                                      List<
                                          charts.Series<TimeSeriesRangeData,
                                              DateTime>>>(
                                      future: rangeSeriesListGy,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                defaultRenderer: charts.BarRendererConfig<DateTime>(
                                                  groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 0.0, maxBarWidthPx: 3, cornerStrategy: const charts.ConstCornerStrategy(4),),

                                                defaultInteractions: false,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
                                  FutureBuilder<
                                      List<
                                          charts.Series<TimeSeriesRangeData,
                                              DateTime>>>(
                                      future: rangeSeriesListGz,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                defaultRenderer: charts.BarRendererConfig<DateTime>(
                                                  groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 0.0, maxBarWidthPx: 3, cornerStrategy: const charts.ConstCornerStrategy(4),),

                                                defaultInteractions: false,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
                                  FutureBuilder<
                                      List<
                                          charts.Series<TimeSeriesRangeData,
                                              DateTime>>>(
                                      future: rangeSeriesListMx,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                defaultRenderer: charts.BarRendererConfig<DateTime>(
                                                  groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 0.0, maxBarWidthPx: 3, cornerStrategy: const charts.ConstCornerStrategy(4),),

                                                defaultInteractions: false,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
                                  FutureBuilder<
                                      List<
                                          charts.Series<TimeSeriesRangeData,
                                              DateTime>>>(
                                      future: rangeSeriesListMy,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                defaultRenderer: charts.BarRendererConfig<DateTime>(
                                                  groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 0.0, maxBarWidthPx: 3, cornerStrategy: const charts.ConstCornerStrategy(4),),

                                                defaultInteractions: false,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
                                  FutureBuilder<
                                      List<
                                          charts.Series<TimeSeriesRangeData,
                                              DateTime>>>(
                                      future: rangeSeriesListMz,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
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
                                                child: Text(
                                                    'Data still processing'),
                                              ),
                                            );
                                          } else {
                                            return SizedBox(
                                              width: width * 0.9,
                                              height: 200,
                                              child: charts.TimeSeriesChart(
                                                axList,
                                                defaultRenderer: charts.BarRendererConfig<DateTime>(
                                                  groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 0.0, maxBarWidthPx: 3, cornerStrategy: const charts.ConstCornerStrategy(4),),

                                                defaultInteractions: false,
                                                animate: true,
                                                dateTimeFactory: const charts
                                                    .LocalDateTimeFactory(),
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              snapshot.error.toString());
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
