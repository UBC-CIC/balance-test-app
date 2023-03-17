import 'package:balance_test/analytics_page.dart';
import 'package:balance_test/past_tests_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'new_test_page_clinic.dart';

int groupValue = 0;

class ClinicPatientPage extends StatefulWidget {
  const ClinicPatientPage({
    Key? key,
    required this.name,
    required this.userID,
  }) : super(key: key);

  final String name;
  final String userID;

  @override
  State<ClinicPatientPage> createState() => _ClinicPatientPageState();
}

class _ClinicPatientPageState extends State<ClinicPatientPage> {
  //VARIABLES

  //METHODS

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<Widget> pages = <Widget>[
      PastTests(parentCtx: context, userID: widget.userID),
      NewTestPageClinic(
        parentCtx: context,
        userID: widget.userID,
      ),
      AnalyticsPage(
        parentCtx: context,
        userID: widget.userID,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff2f1f6),
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
            size: 0.025 * height,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 0.05 * height,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            'Patient Page',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              textStyle: const TextStyle(
                // color: Color.fromRGBO(141, 148, 162, 1.0),
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xfcf2f1f6),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.05*width, 0.01 * height, 0.05*width, 0),
              child:  FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'DMSans-Medium',
                  fontWeight: FontWeight.w600,
                ),
              ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.05*width, 4, 0.05*width, 0),
              child:  FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    color: Color(0xff0061b2),
                    size: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                    child: Text(
                      widget.userID,
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),),
            ),
            SizedBox(
              width: 0.9 * width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: CupertinoSlidingSegmentedControl<int>(
                  backgroundColor: CupertinoColors.lightBackgroundGray,
                  thumbColor: CupertinoColors.extraLightBackgroundGray,
                  padding: const EdgeInsets.fromLTRB(4,3,4,3),
                  groupValue: groupValue,
                  children: const {
                    0: Padding(
                      padding: EdgeInsets.all(7),
                      child: Text("Past Tests")
                    ),
                    1: Padding(
                        padding: EdgeInsets.all(7),
                        child: Text("New Test")
                    ),
                    2: Padding(
                        padding: EdgeInsets.all(7),
                        child: Text("Analytics")
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      groupValue = value!;
                    });
                  },
                ),
              ),
            ),
            pages.elementAt(groupValue), //New
          ],
        ),
      ),
    );
  }
}
