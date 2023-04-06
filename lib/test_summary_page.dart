import 'dart:math';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'loading_page.dart';
import 'package:gaimon/gaimon.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';


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
    required this.formattedMovementType,
    required this.movementType,
    required this.timeElapsed,
    required this.userID,
    required this.isClinicApp,
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
  final String formattedMovementType;
  final String movementType;
  final String timeElapsed;
  final String userID;
  final bool isClinicApp;

  @override
  State<TestSummary> createState() => _TestSummaryState();
}

class _TestSummaryState extends State<TestSummary> {
  //VARIABLES

  final uploadResult = ValueNotifier<String>('none');
  var uuid = const Uuid();
  final TextEditingController notesController = TextEditingController();
  late TextEditingController clinicScoreController = TextEditingController();
  bool showScoreInputWarning = false;
  late bool? allowSharingStateVar;

  //METHODS

  @override
  void initState() {
    super.initState();
    getAllowSharingPrefs();
  }

  Future<void> getAllowSharingPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? allowSharing = prefs.getBool('allowSharing');
    allowSharingStateVar = allowSharing;
  }

  void sendData() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Loading(uploadStatus: uploadResult);
      },
    );
    postRequest().then((value) {
      if (value == true) {
        Gaimon.success();
        FlutterRingtonePlayer.play(
          android: AndroidSounds.alarm,
          ios: const IosSound(1407),
          looping: false,
          volume: 1.0,
        );
        uploadResult.value = 'success';
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            uploadResult.value = 'none';
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          });
        });
      } else {
        Gaimon.error();
        uploadResult.value = 'failed';
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            uploadResult.value = 'none';
            Navigator.pop(context);
          });
        });
      }
    });
  }

  String formatDateTimeDatabase(String input) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }
    DateTime dateTime = DateTime.parse(input).toLocal();
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String outputTimeString = outputFormat.format(dateTime);
    final duration = dateTime.timeZoneOffset, hours = duration.inHours;
    return "$outputTimeString${hours > 0 ? '+' : '-'}${twoDigits(hours.abs())}";
  }


  Future<bool> postRequest() async {
    String testID = uuid.v4();

    DateTime now = DateTime.now();

    String databaseStartTime = formatDateTimeDatabase(widget.timeStampData.first);

    String databaseEndTime = formatDateTimeDatabase(widget.timeStampData.last);

    int shortestLength = [
      widget.timeStampData,
      widget.accelerometerDataX,
      widget.accelerometerDataY,
      widget.accelerometerDataZ,
      widget.gyroscopeDataX,
      widget.gyroscopeDataY,
      widget.gyroscopeDataZ,
      widget.magnetometerDataX,
      widget.magnetometerDataY,
      widget.magnetometerDataZ
    ].map((list) => list.length).reduce(min);

    //Trim start of lists so they are the same lengths
    List<String> timeStampDataTrim = widget.timeStampData.sublist(widget.timeStampData.length - shortestLength);
    List<double> accelerometerDataXTrim = widget.accelerometerDataX.sublist(widget.accelerometerDataX.length - shortestLength);
    List<double> accelerometerDataYTrim = widget.accelerometerDataY.sublist(widget.accelerometerDataY.length - shortestLength);
    List<double> accelerometerDataZTrim = widget.accelerometerDataZ.sublist(widget.accelerometerDataZ.length - shortestLength);
    List<double> gyroscopeDataXTrim = widget.gyroscopeDataX.sublist(widget.gyroscopeDataX.length - shortestLength);
    List<double> gyroscopeDataYTrim = widget.gyroscopeDataY.sublist(widget.gyroscopeDataY.length - shortestLength);
    List<double> gyroscopeDataZTrim = widget.gyroscopeDataZ.sublist(widget.gyroscopeDataZ.length - shortestLength);
    List<double> magnetometerDataXTrim = widget.magnetometerDataX.sublist(widget.magnetometerDataX.length - shortestLength);
    List<double> magnetometerDataYTrim = widget.magnetometerDataY.sublist(widget.magnetometerDataY.length - shortestLength);
    List<double> magnetometerDataZTrim = widget.magnetometerDataZ.sublist(widget.magnetometerDataZ.length - shortestLength);

    final Map<String, Object> arrayMap = {};
    arrayMap["user_id"] = widget.userID;
    arrayMap["movement"] = widget.movementType;
    arrayMap["testID"] = testID;
    clinicScoreController.text.isNotEmpty ? arrayMap["training"] = true : arrayMap["training"] = false;
    clinicScoreController.text.isNotEmpty ? arrayMap["clinic_score"] = clinicScoreController.text : () {};
    arrayMap["start_date"] = "${now.year}-${now.month}-${now.day}";
    arrayMap["ts"] = timeStampDataTrim;
    arrayMap["ax"] = accelerometerDataXTrim;
    arrayMap["ay"] = accelerometerDataYTrim;
    arrayMap["az"] = accelerometerDataZTrim;
    arrayMap["gx"] = gyroscopeDataXTrim;
    arrayMap["gy"] = gyroscopeDataYTrim;
    arrayMap["gz"] = gyroscopeDataZTrim;
    arrayMap["mx"] = magnetometerDataXTrim;
    arrayMap["my"] = magnetometerDataYTrim;
    arrayMap["mz"] = magnetometerDataZTrim;

    String body = json.encode(arrayMap);

    String key =
        'movement=${widget.movementType}/year=${now.year.toString()}/month=${now.month.toString()}/day=${now.day.toString()}/test_event_id=$testID.json';

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/recording.json')
      ..createSync()
      ..writeAsStringSync(body);

    //Upload to RDS
    try {
      var query = '''
        mutation MyMutation {
          putTestResult(
            start_time: "$databaseStartTime",
            end_time: "$databaseEndTime",
            notes: "${notesController.text}",
            patient_id: "${widget.userID}",
            test_event_id: "$testID",
            test_type: "${widget.movementType}") {
            notes
          }
        }
      ''';

      await Amplify.API.query(request: GraphQLRequest<String>(document: query, variables: {'patient_id': widget.userID})).response;
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
      return false;
    }

    // Upload the file to S3
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: tempFile,
          options: UploadFileOptions(
            accessLevel: StorageAccessLevel.private,
          ),
          key: key,
          onProgress: (progress) {
            safePrint('Fraction completed: ${progress.getFractionCompleted()}');
          });
      safePrint('Successfully uploaded file: ${result.key}');
    } on StorageException catch (e) {
      try {
        if (kDebugMode) {
          print('deleting from rds');
        }

        var query = '''
        mutation MyMutation {
          deleteTestEventFromDB(patient_id: "${widget.userID}", test_event_id: "$testID")
        }
      ''';

        await Amplify.API.query(request: GraphQLRequest<String>(document: query, variables: {'patient_id': widget.userID})).response;
      } on ApiException catch (e) {
        if (kDebugMode) {
          print('Query failed: $e');
        }
        return false;
      }
      safePrint('Error uploading file: $e');
      return false;
    }
    return true;
  }

  bool isNumber(String string) {
    // Null or empty string is not a number
    if (string.isEmpty) {
      return false;
    }

    // Try to parse input string to number.
    // Both integer and double work.
    // Use int.tryParse if you want to check integer only.
    // Use double.tryParse if you want to check double only.
    final number = num.tryParse(string);

    if (number == null) {
      return false;
    }

    return true;
  }

  void updateFilledStatus(String text) {
    if (clinicScoreController.text.isEmpty ||
        (isNumber(clinicScoreController.text) &&
            (clinicScoreController.text.isNotEmpty && int.parse(clinicScoreController.text) <= 100 && int.parse(clinicScoreController.text) >= 0))) {
      setState(() {
        showScoreInputWarning = false;
      });
    } else {
      setState(() {
        showScoreInputWarning = true;
      });
    }
  }

//UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String movementType = widget.formattedMovementType;

    String timeElapsed = widget.timeElapsed;

    return Scaffold(
      backgroundColor: const Color(0xfff2f1f6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // Removes back button from appbar
        toolbarHeight: 0.05 * height,
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
              fontSize: 26,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                          padding: const EdgeInsets.fromLTRB(26.0, 20, 26, 0),
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
                                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                            '$timeElapsed sec',
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
                        widget.isClinicApp
                            ? Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0.05 * width, 0.02 * height, 0.05 * width, 0),
                                    child: Container(
                                      decoration: BoxDecoration(color: const Color(0x0A3F51B5), borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.fromLTRB(0.06 * width, 8, 0, 6),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CupertinoTextField.borderless(
                                            controller: clinicScoreController,
                                            maxLength: 3,
                                            onChanged: updateFilledStatus,
                                            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                                            padding: const EdgeInsets.only(left: 45, top: 6, right: 6, bottom: 6),
                                            prefix: const Text(
                                              'Assign Score',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            placeholder: 'Optional',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  showScoreInputWarning
                                      ? Padding(
                                          padding: EdgeInsets.fromLTRB(0.1 * width, 10, 0.05 * width, 0),
                                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                                child: Icon(
                                                  CupertinoIcons.exclamationmark_circle,
                                                  size: 16,
                                                  color: Colors.red,
                                                )),
                                            Flexible(
                                              child: Text(
                                                'Please enter a score between 0-100',
                                                style: TextStyle(fontSize: 15, color: Colors.red),
                                              ),
                                            )
                                          ]),
                                        )
                                      : Container(),
                                ],
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: SizedBox(
                            height: 270,
                            width: 0.82 * width,
                            child: TextField(
                              controller: notesController,
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
                                        backgroundColor: const Color(0xffECEDF0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
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
                                    onPressed: () async {
                                      if (showScoreInputWarning) {
                                      } else if (!widget.isClinicApp && (allowSharingStateVar == null || allowSharingStateVar == false)) {
                                        await showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) => CupertinoAlertDialog(
                                            title: const Text('Allow "Balance Test" to share recorded IMU sensor data with your care provider?'),
                                            content: const Text('Your data will be used to assess your balance.'),
                                            actions: <CupertinoDialogAction>[
                                              CupertinoDialogAction(
                                                /// This parameter indicates the action would perform
                                                /// a destructive action such as deletion, and turns
                                                /// the action's text color to red.
                                                isDestructiveAction: true,
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Deny'),
                                              ),
                                              CupertinoDialogAction(
                                                /// This parameter indicates this action is the default,
                                                /// and turns the action's text to bold text.
                                                isDefaultAction: true,
                                                onPressed: () async {
                                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  await prefs.setBool('allowSharing', true);
                                                  try {
                                                    var query = '''
                                                                    mutation MyMutation2 {
                                                                      recordConsentDate(date: "${formatDateTimeDatabase(DateTime.now().toString())}", patient_id: "${widget.userID}") {
                                                                        privacy_consent_date
                                                                       }
                                                                    } 
                                                                  ''';

                                                    final response = await Amplify.API
                                                        .query(
                                                            request:
                                                                GraphQLRequest<String>(document: query, variables: {'patient_id': widget.userID}))
                                                        .response;

                                                    if (response.data == null) {
                                                      if (kDebugMode) {
                                                        print('errors: ${response.errors}');
                                                      }
                                                    } else {
                                                    }
                                                  } on ApiException catch (e) {
                                                    if (kDebugMode) {
                                                      print('Query failed: $e');
                                                    }
                                                  }
                                                  allowSharingStateVar = true;
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: const Text('Allow'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        sendData();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          //border radius equal to or more than 50% of width
                                        )),
                                    child: const Icon(CupertinoIcons.paperplane_fill)),
                              ),
                            ],
                          ),
                        ),
                      ],
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
