import 'package:balance_test/recording_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'TestItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.parentCtx, required this.userID}) : super(key: key);

  final BuildContext parentCtx;
  final String userID;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //VARIABLES

  //Controller for fading scroll view

  List<TestItem> testList = getTests();

  static List<TestItem> getTests() {
    const data = [
      {
        "movement": "sit-to-stand",
      },
      {
        "movement": "stand-unsupported",
      },
      {
        "movement": "stand-to-sit",
      },
      {
        "movement": "transfers",
      },
      {
        "movement": "stand-eyes-closed",
      },
      {
        "movement": "stand-feet-together",
      },
      {
        "movement": "stand-reaching-forward",
      },
      {
        "movement": "pick-up-object",
      },
      {
        "movement": "look-behind-shoulders",
      },
      {
        "movement": "360-turn",
      },
      {
        "movement": "alternate-foot",
      },
      {
        "movement": "one-foot-in-front",
      },
      {
        "movement": "stand-one-leg",
      },
    ];

    List<TestItem> testList = data.map<TestItem>(TestItem.fromJson).toList();
    testList.sort((a, b) => convertMovementName(a.movement).compareTo(convertMovementName(b.movement)));
    return testList;
  }

  static String convertMovementName(String movement) {
    if (movement == 'sit-to-stand') {
      return 'Sit to Stand';
    } else if (movement == 'stand-unsupported') {
      return 'Stand\nUnsupported';
    } else if (movement == 'sit-back-unsupported') {
      return 'Sitting with\nBack Unsupported\nFeet Supported';
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
                                        fontSize: 25,
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
