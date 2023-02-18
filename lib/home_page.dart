import 'package:balance_test/recording_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'TestItem.dart';
import 'my_fading_scrollview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.parentCtx}) : super(key: key);

  final BuildContext parentCtx;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //VARIABLES

  //Controller for fading scroll view
  final controller = ScrollController();

  List<TestItem> testList = getTests();

  static List<TestItem> getTests() {
    const data = [
      {
        "movement": "sit-to-stasdlijfaosijdfodijnd",
      },
      {
        "movement": "sit-to-stand",
      },
      {
        "movement": "sit-to-stand",
      },
      {
        "movement": "sit-to-stand",
      },
      {
        "movement": "sit-to-stand",
      },
      {
        "movement": "sit-to-stand",
      },
      {
        "movement": "sit-to-stand",
      },
      {
        "movement": "sit-to-stand",
      },
    ];

    List<TestItem> testList = data.map<TestItem>(TestItem.fromJson).toList();
    testList.sort((a, b) => a.movement.compareTo(b.movement));
    return testList;
  }

  String convertMovementName(String movement) {
    if (movement == 'sit-to-stand') {
      return 'Sit to Stand';
    } else {
      return 'Sitting with\nBack Unsupported\nFeet Supported';
    }
  }

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Widget buildTestList(List<TestItem> tests) => ListView.builder(
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
                  fontFamily: 'DMSans-Bold',
                  fontSize: 0.055 * width,
                ),
              ),
            );
          } else {
            final test = tests[index - 1];

            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: Center(
                child: Card(
                  color: const Color(0xffffffff),
                  elevation: 1,
                  shadowColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    width: width * 0.90,
                    height: 155,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 15, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 85,
                                width: 0.5 * width,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    // 'Sitting with\nBack Unsupported\nFeet Supported',
                                    convertMovementName(test.movement),
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Color(0xff2A2A2A),
                                        // fontFamily: 'DMSans-Bold',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        color: Color(0xff006CC6)),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                      child: Text(
                                        '1 Minute',
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                            color: Color(0xff006CC6),
                                            fontFamily: 'DMSans-Medium',
                                            fontSize: 20,
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
                            child: SizedBox(
                              height: 70,
                              width: 0.28 * width,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      widget.parentCtx,
                                      //Used to pop to main page instead of home
                                      MaterialPageRoute(
                                          builder: (context) => RecordingPage(
                                                movementType:
                                                    convertMovementName(
                                                        test.movement),
                                              )));
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color(0xff006CC6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      //border radius equal to or more than 50% of width
                                    )),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Start',
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'DMSans-Medium',
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.play_arrow_rounded)
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

    return Expanded(child: buildTestList(testList));
  }
}
