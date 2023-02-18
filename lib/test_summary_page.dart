import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'dart:math';
import 'loading_page.dart';
import 'package:gaimon/gaimon.dart';

import 'my_fading_scrollview.dart';

class TestSummary extends StatefulWidget {
  const TestSummary({
    Key? key,
    required this.timeStampData,
    required this.accelerometerDataX,
    required this.accelerometerDataY,
    required this.accelerometerDataZ,
    required this.gyroscopeDataX,
    required this.gyroscopeDataY,
    required this.gyroscopeDataZ,
    required this.magnetometerDataX,
    required this.magnetometerDataY,
    required this.magnetometerDataZ,
    required this.movementType,
    required this.timeElapsed,
  }) : super(key: key);

  final List<String> timeStampData;
  final List<double> accelerometerDataX;
  final List<double> accelerometerDataY;
  final List<double> accelerometerDataZ;
  final List<double> gyroscopeDataX;
  final List<double> gyroscopeDataY;
  final List<double> gyroscopeDataZ;
  final List<double> magnetometerDataX;
  final List<double> magnetometerDataY;
  final List<double> magnetometerDataZ;
  final String movementType;
  final String timeElapsed;

  @override
  State<TestSummary> createState() => _TestSummaryState();
}

class _TestSummaryState extends State<TestSummary> {
  //VARIABLES
  final _showCheck = ValueNotifier<bool>(false);
  final controller = ScrollController();

  //METHODS

  showLoaderDialog(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Container(
        width: 230,
        height: 230,
        child: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: const Text("Loading...")),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void sendData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Loading(showCheckmark: _showCheck);
      },
    );
    postRequest().then((value) {
      Gaimon.success();
      FlutterRingtonePlayer.play(
        android: AndroidSounds.alarm,
        ios: const IosSound(1407),
        looping: false,
        volume: 1.0,
      );
      print("returned from post request");
      _showCheck.value = true;
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showCheck.value = false;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        });
      });
    });
  }

  // Converts movement title name to api format
  String convertMovementType() {
    if (widget.movementType == "Sit to Stand") {
      return "sit-to-stand";
    }
    return "";
  }

  // Future<http.Response> postRequest() async {
    Future<void> postRequest() async {
    final Map<String, Map<String, Object>> jsonMap = {};

    int tsLength = widget.timeStampData.length;
    int axLength = widget.accelerometerDataX.length;
    int ayLength = widget.accelerometerDataY.length;
    int azLength = widget.accelerometerDataZ.length;
    int gxLength = widget.gyroscopeDataX.length;
    int gyLength = widget.gyroscopeDataY.length;
    int gzLength = widget.gyroscopeDataZ.length;
    int mxLength = widget.magnetometerDataX.length;
    int myLength = widget.magnetometerDataY.length;
    int mzLength = widget.magnetometerDataZ.length;

    int minLen = [
      tsLength,
      axLength,
      ayLength,
      azLength,
      gxLength,
      gyLength,
      gzLength,
      mxLength,
      myLength,
      mzLength
    ].reduce(min);

    print(minLen);

    for (var i = 0; i < minLen; i++) {
      Map<String, Object> dataPointMap = {};
      dataPointMap["patient_id"] = "app-testing";
      dataPointMap["movement"] = convertMovementType();
      dataPointMap["ts"] = widget.timeStampData[i + tsLength - minLen];
      dataPointMap["ax"] = widget.accelerometerDataX[i + axLength - minLen];
      dataPointMap["ay"] = widget.accelerometerDataY[i + ayLength - minLen];
      dataPointMap["az"] = widget.accelerometerDataZ[i + azLength - minLen];
      dataPointMap["gx"] = widget.gyroscopeDataX[i + gxLength - minLen];
      dataPointMap["gy"] = widget.gyroscopeDataY[i + gyLength - minLen];
      dataPointMap["gz"] = widget.gyroscopeDataZ[i + gzLength - minLen];
      dataPointMap["mx"] = widget.magnetometerDataX[i + mxLength - minLen];
      dataPointMap["my"] = widget.magnetometerDataY[i + myLength - minLen];
      dataPointMap["mz"] = widget.magnetometerDataZ[i + mzLength - minLen];
      jsonMap[i.toString()] = dataPointMap;
    }

    String body = json.encode(jsonMap);

    List<int> jsonBytes = utf8.encode(body);
    double jsonSizeInMB = jsonBytes.length / pow(1024, 2);
    print('JSON size: $jsonSizeInMB MB');
    print(widget.timeStampData[0]);

    // final Map<String, Object> arrayMap = {};
    // arrayMap["patient_id"] = "app-testing";
    // arrayMap["movement"] = "sit-to-stand";
    // arrayMap["ts"] = widget.timeStampData;
    // arrayMap["ax"] = widget.accelerometerDataX;
    // arrayMap["ay"] = widget.accelerometerDataY;
    // arrayMap["az"] = widget.accelerometerDataZ;
    // arrayMap["gx"] = widget.gyroscopeDataX;
    // arrayMap["gy"] = widget.gyroscopeDataY;
    // arrayMap["gz"] = widget.gyroscopeDataZ;
    // arrayMap["mx"] = widget.magnetometerDataX;
    // arrayMap["my"] = widget.magnetometerDataY;
    // arrayMap["mz"] = widget.magnetometerDataZ;
    //
    // String arrayJson = json.encode(arrayMap);
    // List<int> jsonBytesarray = utf8.encode(arrayJson);
    // double jsonSizeInMBarray = jsonBytesarray.length / pow(1024, 2);
    // print('JSON size: $jsonSizeInMBarray MB');

    await Future.delayed(const Duration(seconds: 2));
    return;

    int before = DateTime.now()
        .millisecondsSinceEpoch; // Used to show animation for >= 2 seconds
    var url = Uri.https('ox515vr0t5.execute-api.ca-central-1.amazonaws.com',
        '/data-workflow-beta/data_input/json');
    var response = await http.post(url,
        //headers: {"Content-Type": "application/json"},
        body: body);
    print("${response.statusCode}");
    print("${response.body}");
    int after = DateTime.now().millisecondsSinceEpoch;
    if (((after - before) / 1000) < 2) {
      await Future.delayed(Duration(milliseconds: (2000 - (after - before))));
    }
    // return response;
  }

//UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String movementType = widget.movementType;

    String timeElapsed = widget.timeElapsed;

    return Scaffold(
        backgroundColor: const Color(0xfff2f1f6),
        appBar: AppBar(
          automaticallyImplyLeading: false,   // Removes back button from appbar
          toolbarHeight: 0.1 * height,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light, // light for black status bar
          ),
          title: Text(
            'Review Details',
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(
                // color: Color.fromRGBO(141, 148, 162, 1.0),
                color: Colors.black,
                fontFamily: 'DMSans-Regular',
                fontSize: 32,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: FadingEdgeScrollView.fromSingleChildScrollView(
    child: SingleChildScrollView(
        controller: controller,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Center(
              child: Card(
                color: Colors.white,
                elevation: 10,
                shadowColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SizedBox(
                  width: width * 0.9,
                  height: null,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(26.0, 20, 0, 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Row(
                                children: const [
                                  Text(
                                    'Summary',
                                    style: TextStyle(
                                      color: Color(0xff2A2A2A),
                                      fontFamily: 'DMSans-Medium',
                                      fontSize: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.accessibility_new_rounded,
                                    size: 55,
                                    color: Colors.indigo,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Movement',
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontFamily: 'DMSans-Medium',
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          movementType,
                                          style: const TextStyle(
                                            color: Color(0xff2A2A2A),
                                            fontFamily: 'DMSans-Medium',
                                            fontSize: 26,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 7, 0, 18),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 55,
                                    color: Colors.indigo,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Test Duration',
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontFamily: 'DMSans-Medium',
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '$timeElapsed min',
                                          style: const TextStyle(
                                            color: Color(0xff2A2A2A),
                                            fontFamily: 'DMSans-Medium',
                                            fontSize: 26,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 270,
                        width: 0.82 * width,
                        child: TextField(
                          maxLines: 13,
                          minLines: 13,
                          maxLength: 500,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0x0A3F51B5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                width: 1,
                                style: BorderStyle.none,
                              ),
                            ),
                            hintText: 'Enter Additional Notes...',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 70,
                                  width: 0.4 * width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            const Color(0xffECEDF0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          //border radius equal to or more than 50% of width
                                        )),
                                    child: const Icon(
                                      CupertinoIcons.back,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  )),
                              SizedBox(
                                height: 70,
                                width: 0.4 * width,
                                child: ElevatedButton(
                                    onPressed: sendData,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          //border radius equal to or more than 50% of width
                                        )),
                                    child: const Icon(CupertinoIcons.paperplane_fill)),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]))));
  }
}
