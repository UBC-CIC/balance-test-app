import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:balance_test/test_summary.dart';
import 'package:google_fonts/google_fonts.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({
    Key? key,
    required this.movementType,
  }) : super(key: key);

  final String movementType;

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  //VARIABLES

  List<String> timeStampData = [];
  List<double> accelerometerDataX = [];
  List<double> accelerometerDataY = [];
  List<double> accelerometerDataZ = [];
  List<double> gyroscopeDataX = [];
  List<double> gyroscopeDataY = [];
  List<double> gyroscopeDataZ = [];
  List<double> magnetometerDataX = [];
  List<double> magnetometerDataY = [];
  List<double> magnetometerDataZ = [];

  bool recordingStarted = false; //To show start/stop button

  final _streamSubscriptions =
      <StreamSubscription<dynamic>>[]; //Recording Stream

  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  //FUNCTIONS

  @override
  void initState() {
    super.initState();
    setUpdateInterval(100);
  }

  void setUpdateInterval(int interval) {
    motionSensors.accelerometerUpdateInterval = interval;
    motionSensors.gyroscopeUpdateInterval = interval;
    motionSensors.magnetometerUpdateInterval = interval;
  }

  void clearLists() {
    timeStampData.clear();
    accelerometerDataX.clear();
    accelerometerDataY.clear();
    accelerometerDataZ.clear();
    gyroscopeDataX.clear();
    gyroscopeDataY.clear();
    gyroscopeDataZ.clear();
    magnetometerDataX.clear();
    magnetometerDataY.clear();
    magnetometerDataZ.clear();
  }

//Starts the stopwatch and timer to update state every 1 second
  void startTimer() {
    stopwatch.reset();
    setState(() {
      stopwatch.start();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {});
        if(stopwatch.elapsedMilliseconds>150000) {
          for (final subscription in _streamSubscriptions) {
            subscription.cancel();
          }

          String timeElapsed =
              '${stopwatch.elapsed.inMinutes}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
          setState(() {
            stopTimer();
          });

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TestSummary(
                  movementType: widget.movementType,
                  timeStampData: timeStampData,
                  accelerometerDataX:
                  accelerometerDataX,
                  accelerometerDataY:
                  accelerometerDataY,
                  accelerometerDataZ:
                  accelerometerDataZ,
                  gyroscopeDataX: gyroscopeDataX,
                  gyroscopeDataY: gyroscopeDataY,
                  gyroscopeDataZ: gyroscopeDataZ,
                  magnetometerDataX: magnetometerDataX,
                  magnetometerDataY: magnetometerDataY,
                  magnetometerDataZ: magnetometerDataZ,
                  timeElapsed: timeElapsed,
                )),
          );
          setState(() {
            recordingStarted = false;
          });
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      stopwatch.stop();
      stopwatch.reset();
    });
  }

  //Starts recording streams and stopwatch timer
  startRecording() {
    startTimer();

    clearLists();
    _streamSubscriptions
        .add(motionSensors.accelerometer.listen((AccelerometerEvent event) {
      timeStampData.add("${DateTime.now().toLocal().toString()} "
          "${formattedTimeZoneOffset(DateTime.now())}");
      accelerometerDataX.add(event.x);
      accelerometerDataY.add(event.y);
      accelerometerDataZ.add(event.z);
    }));
    _streamSubscriptions
        .add(motionSensors.gyroscope.listen((GyroscopeEvent event) {
      gyroscopeDataX.add(event.x);
      gyroscopeDataY.add(event.y);
      gyroscopeDataZ.add(event.z);
    }));
    _streamSubscriptions
        .add(motionSensors.magnetometer.listen((MagnetometerEvent event) {
      magnetometerDataX.add(event.x);
      magnetometerDataY.add(event.y);
      magnetometerDataZ.add(event.z);
    }));
    setState(() {
      recordingStarted = true;
    });
  }

  //Formats time zone offset to be in +/-xx:xx format
  String formattedTimeZoneOffset(DateTime time) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final duration = time.timeZoneOffset,
        hours = duration.inHours,
        minutes = duration.inMinutes.remainder(60).abs().toInt();

    return '${hours > 0 ? '+' : '-'}${twoDigits(hours.abs())}:${twoDigits(minutes)}';
  }

  //UI

  @override
  Widget build(BuildContext context) {

    String title = widget.movementType;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0.1 * height,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(141, 148, 162, 1.0),
                fontFamily: 'DMSans-Regular',
                fontSize: 32,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(0, 0.15*height, 0, 0.05*height),
              child:
              Text(
                '${stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                style: GoogleFonts.varelaRound(textStyle:const TextStyle(
                  color: Color(0xff2A2A2A),
                  fontSize: 70,
                ),),
              ),),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0.05*height, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        height: 125,
                        width: 125,
                        child: ElevatedButton(
                          onPressed: () {
                            stopTimer();
                            for (final subscription in _streamSubscriptions) {
                              subscription.cancel();
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffECEDF0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(62.5),
                                //border radius equal to or more than 50% of width
                              )),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        )),
                    if (!recordingStarted)
                      SizedBox(
                          height: 125,
                          width: 125,
                          child: ElevatedButton(
                            onPressed: startRecording,
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(62.5),
                              //border radius equal to or more than 50% of width
                            )),
                            child: const Icon(Icons.play_arrow_rounded),
                          )),
                    if (recordingStarted)
                      SizedBox(
                          height: 125,
                          width: 125,
                          child: ElevatedButton(
                            onPressed: () {
                              for (final subscription in _streamSubscriptions) {
                                subscription.cancel();
                              }

                              String timeElapsed =
                                  '${stopwatch.elapsed.inMinutes}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
                              setState(() {
                                stopTimer();
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TestSummary(
                                          movementType: title,
                                          timeStampData: timeStampData,
                                          accelerometerDataX:
                                              accelerometerDataX,
                                          accelerometerDataY:
                                              accelerometerDataY,
                                          accelerometerDataZ:
                                              accelerometerDataZ,
                                          gyroscopeDataX: gyroscopeDataX,
                                          gyroscopeDataY: gyroscopeDataY,
                                          gyroscopeDataZ: gyroscopeDataZ,
                                          magnetometerDataX: magnetometerDataX,
                                          magnetometerDataY: magnetometerDataY,
                                          magnetometerDataZ: magnetometerDataZ,
                                          timeElapsed: timeElapsed,
                                        )),
                              );
                              setState(() {
                                recordingStarted = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffD55A1B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(62.5),
                                  //border radius equal to or more than 50% of width
                                )),
                            child: const Icon(Icons.stop_rounded),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
