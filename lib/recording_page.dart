import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:gaimon/gaimon.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:balance_test/test_summary_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'countdown_page.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({
    Key? key,
    required this.movementType,
    required this.formattedMovementType,
    required this.userID,
    required this.isClinicApp,
  }) : super(key: key);

  final String movementType;
  final String formattedMovementType;
  final String userID;
  final bool isClinicApp;

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

  final _streamSubscriptions = <StreamSubscription<dynamic>>[]; //Recording Stream

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
        if (stopwatch.elapsedMilliseconds > 150000) {
          for (final subscription in _streamSubscriptions) {
            subscription.cancel();
          }

          String timeElapsed = '${stopwatch.elapsed.inMinutes}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
          setState(() {
            stopTimer();
          });

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TestSummary(
                      formattedMovementType: widget.formattedMovementType,
                      movementType: widget.movementType,
                      timeStampData: timeStampData,
                      accelerometerDataX: accelerometerDataX,
                      accelerometerDataY: accelerometerDataY,
                      accelerometerDataZ: accelerometerDataZ,
                      gyroscopeDataX: gyroscopeDataX,
                      gyroscopeDataY: gyroscopeDataY,
                      gyroscopeDataZ: gyroscopeDataZ,
                      magnetometerDataX: magnetometerDataX,
                      magnetometerDataY: magnetometerDataY,
                      magnetometerDataZ: magnetometerDataZ,
                      timeElapsed: timeElapsed,
                      userID: widget.userID,
                      isClinicApp: widget.isClinicApp,
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
    if (kDebugMode) {
      print(timeStampData.length);
    }
  }

  //Starts recording streams and stopwatch timer
  startRecording() async {
    SharedPreferences.getInstance().then((prefs) {
      final countdown = prefs.getInt('countdown') ?? 5;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CountDownPage(
            countdownDuration: countdown,
          );
        },
      ).then((value) {
        Gaimon.warning();

        FlutterRingtonePlayer.play(
          android: AndroidSounds.alarm,
          ios: const IosSound(1115),
          looping: false,
          asAlarm: false,
          volume: 1.0,
        );

        startTimer();

        clearLists();
        _streamSubscriptions.add(motionSensors.accelerometer.listen((AccelerometerEvent event) {
          timeStampData.add("${DateTime.now().toLocal().toString()} "
              "${formattedTimeZoneOffset(DateTime.now())}");
          accelerometerDataX.add(event.x);
          accelerometerDataY.add(event.y);
          accelerometerDataZ.add(event.z);
        }));
        _streamSubscriptions.add(motionSensors.gyroscope.listen((GyroscopeEvent event) {
          gyroscopeDataX.add(event.x);
          gyroscopeDataY.add(event.y);
          gyroscopeDataZ.add(event.z);
        }));
        _streamSubscriptions.add(motionSensors.magnetometer.listen((MagnetometerEvent event) {
          magnetometerDataX.add(event.x);
          magnetometerDataY.add(event.y);
          magnetometerDataZ.add(event.z);
        }));
        setState(() {
          recordingStarted = true;
        });
      });
    });
  }

  //Formats time zone offset to be in +/-xx:xx format
  String formattedTimeZoneOffset(DateTime time) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final duration = time.timeZoneOffset, hours = duration.inHours, minutes = duration.inMinutes.remainder(60).abs().toInt();

    return '${hours > 0 ? '+' : '-'}${twoDigits(hours.abs())}:${twoDigits(minutes)}';
  }

  void stopRecording() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    Gaimon.warning();

    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,
      ios: const IosSound(1116),
      looping: false,
      volume: 1.0,
    );

    String timeElapsed = '${stopwatch.elapsed.inMinutes}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
    setState(() {
      stopTimer();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TestSummary(
                formattedMovementType: widget.formattedMovementType,
                movementType: widget.movementType,
                timeStampData: timeStampData,
                accelerometerDataX: accelerometerDataX,
                accelerometerDataY: accelerometerDataY,
                accelerometerDataZ: accelerometerDataZ,
                gyroscopeDataX: gyroscopeDataX,
                gyroscopeDataY: gyroscopeDataY,
                gyroscopeDataZ: gyroscopeDataZ,
                magnetometerDataX: magnetometerDataX,
                magnetometerDataY: magnetometerDataY,
                magnetometerDataZ: magnetometerDataZ,
                timeElapsed: timeElapsed,
                userID: widget.userID,
                isClinicApp: widget.isClinicApp,
              )),
    );
    setState(() {
      recordingStarted = false;
    });
  }

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          if (recordingStarted) {
            stopRecording();
          }
        },
        child: Scaffold(
          backgroundColor: recordingStarted ? const Color(0xfffe3d30) : const Color(0xfff2f1f6),
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light, // light for black status bar
            ),
            leading: !recordingStarted? SizedBox(
              height: 0.06 * height,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(
                  CupertinoIcons.chevron_back,
                  color: Colors.black,
                  size: 0.03 * height,
                ),
                onPressed: () {
                  stopTimer();
                  for (final subscription in _streamSubscriptions) {
                    subscription.cancel();
                  }
                  Navigator.pop(context);
                },
              ),
            ) : Container(),
            toolbarHeight: 0.12 * height,
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(
                height: 0.06 * height,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.formattedMovementType,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        // color: Color.fromRGBO(141, 148, 162, 1.0),
                        color: Colors.black,
                        // fontFamily: 'DMSans-Regular',
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0.12 * height, 0, 0.05 * height),
                child: Text(
                  '${stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                      color: recordingStarted ? Colors.white : const Color(0xff2A2A2A),
                      fontSize: 70,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0.05 * height, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!recordingStarted)
                      SizedBox(
                          height: 0.45 * width,
                          width: 0.45 * width,
                          child: ElevatedButton(
                            onPressed: () {
                              startRecording();
                              Gaimon.selection();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff006CC6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.25 * width),
                                  //border radius equal to or more than 50% of width
                                )),
                            child: Text(
                              'Start',
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'DMSans-Medium',
                                  fontSize: 38,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )),
                    if (recordingStarted)
                      SizedBox(
                          height: 0.4 * width,
                          width: 0.4 * width,
                          child: const Icon(
                            Icons.stop_rounded,
                            size: 80,
                            color: Colors.white,
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
