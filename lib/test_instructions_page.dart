import 'package:balance_test/recording_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:google_fonts/google_fonts.dart';

class TestInstructionsPage extends StatefulWidget {
  const TestInstructionsPage({
    Key? key,
    required this.movementType,
    required this.formattedMovementType,
    required this.userID,
    required this.instructions,
    required this.isClinicApp,
  }) : super(key: key);

  final String movementType;
  final String formattedMovementType;
  final String userID;
  final String instructions;
  final bool isClinicApp;

  @override
  State<TestInstructionsPage> createState() => _TestInstructionsPageState();
}

class _TestInstructionsPageState extends State<TestInstructionsPage> {
  //VARIABLES

  //METHODS

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
            widget.formattedMovementType,
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
                                  CupertinoIcons.book,
                                  size: 24,
                                  color: Color(0xff006CC6),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Text(
                                    'Instructions',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Color(0xff006CC6),
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
                            child: Text(
                              widget.instructions,
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
                            height: 25,
                            thickness: 1,
                            indent: 5,
                            endIndent: 5,
                            color: Colors.transparent,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: SizedBox(
                                    height: 60,
                                    width: 0.28 * width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Gaimon.selection();
                                        Navigator.push(
                                            context,
                                            //Used to pop to main page instead of home
                                            MaterialPageRoute(
                                                builder: (context) => RecordingPage(
                                                      movementType: widget.movementType,
                                                      userID: widget.userID,
                                                      formattedMovementType: widget.formattedMovementType,
                                                      isClinicApp: widget.isClinicApp,
                                                    )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: const Color(0xff006CC6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            //border radius equal to or more than 50% of width
                                          )),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                                              child: Text(
                                                'Begin',
                                                style: GoogleFonts.nunito(
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'DMSans-Medium',
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              CupertinoIcons.chevron_right,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 22,
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
            const Divider(
              height: 22,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
