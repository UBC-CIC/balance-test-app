import 'package:balance_test/recording_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Expanded(
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: controller,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0.05 * width, 0, 0),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
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
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 32, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // 'Sitting with\nBack Unsupported\nFeet Supported',
                                    'Sit to Stand',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Color(0xff2A2A2A),
                                        // fontFamily: 'DMSans-Bold',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded,
                                            color: Color(0xff006CC6)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
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
                                              builder: (context) =>
                                                  const RecordingPage(
                                                    movementType:
                                                        "Sit to Stand",
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            const Color(0xff006CC6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                ),
                Padding(
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
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 32, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // 'Sitting with\nBack Unsupported\nFeet Supported',
                                    'Sit to Stand',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Color(0xff2A2A2A),
                                        // fontFamily: 'DMSans-Bold',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded,
                                            color: Color(0xff006CC6)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
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
                                              builder: (context) =>
                                                  const RecordingPage(
                                                    movementType:
                                                        "Sit to Stand",
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            const Color(0xff006CC6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                ),
                Padding(
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
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 32, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // 'Sitting with\nBack Unsupported\nFeet Supported',
                                    'Sit to Stand',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Color(0xff2A2A2A),
                                        // fontFamily: 'DMSans-Bold',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded,
                                            color: Color(0xff006CC6)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
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
                                              builder: (context) =>
                                                  const RecordingPage(
                                                    movementType:
                                                        "Sit to Stand",
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            const Color(0xff006CC6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                ),
                Padding(
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
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 32, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // 'Sitting with\nBack Unsupported\nFeet Supported',
                                    'Sit to Stand',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Color(0xff2A2A2A),
                                        // fontFamily: 'DMSans-Bold',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded,
                                            color: Color(0xff006CC6)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
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
                                              builder: (context) =>
                                                  const RecordingPage(
                                                    movementType:
                                                        "Sit to Stand",
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            const Color(0xff006CC6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                ),
                Padding(
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
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 32, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // 'Sitting with\nBack Unsupported\nFeet Supported',
                                    'Sit to Stand',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Color(0xff2A2A2A),
                                        // fontFamily: 'DMSans-Bold',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded,
                                            color: Color(0xff006CC6)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
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
                                              builder: (context) =>
                                                  const RecordingPage(
                                                    movementType:
                                                        "Sit to Stand",
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            const Color(0xff006CC6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                ),
              ])),
        ),
      ),
    );
  }
}
