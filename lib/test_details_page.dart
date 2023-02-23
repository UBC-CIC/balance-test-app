import 'package:balance_test/TestDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestDetailsPage extends StatefulWidget {
  const TestDetailsPage({Key? key, required this.testID}) : super(key: key);

  final String testID;

  @override
  State<TestDetailsPage> createState() => _TestDetailsPageState();
}

class _TestDetailsPageState extends State<TestDetailsPage> {
  //VARIABLES
  final controller = ScrollController();

  TestDetails testDetails = getTestDetails();

  static TestDetails getTestDetails() {
    const data = {
      "testID": "1", //UUID format
      "movement": "sit-to-stand",
      "dateTime": "2023-02-10 15:14:40.731703 -08:00",
      "score": 72,
    };
    return TestDetails.fromJson(data);
  }

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
          leading: GestureDetector(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.black,
                    size: 32,
                  ),
                ]),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          toolbarHeight: 0.06 * height,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              'Test Details',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  // color: Color.fromRGBO(141, 148, 162, 1.0),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: const Color(0xfcf2f1f6),
        ),
        body: SingleChildScrollView(
            controller: controller,
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
                        elevation: 2,
                        shadowColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                          width: width * 0.9,
                          height: null,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(22.0, 15, 22.0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.accessibility_new_rounded,
                                        size: 24,
                                        color: Colors.indigo,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        child: Text(
                                          'Movement',
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Colors.indigo,
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
                                  //Overflow text pushes to next line
                                  child: Text(
                                    'Sitting with Back\nUnsupported Feet Supported',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 5,
                                  endIndent: 5,
                                  color: Color(0xffcececf),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.calendar,
                                        size: 24,
                                        color: Colors.indigo,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        child: Text(
                                          'Date and Time',
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Colors.indigo,
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
                                  //Overflow text pushes to next line
                                  child: Text(
                                    'Jan 23, 2023 1:40 pm'
                                    '',
                                    style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 25,
                                  thickness: 1,
                                  indent: 5,
                                  endIndent: 5,
                                  color: Color(0xffcececf),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 8),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    CupertinoIcons
                                                        .chart_bar_alt_fill,
                                                    size: 24,
                                                    color: Colors.indigo,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    child: Text(
                                                      'Score',
                                                      style: GoogleFonts.nunito(
                                                        textStyle:
                                                            const TextStyle(
                                                          color: Colors.indigo,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '82',
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '%',
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                      color: Color(0xff777586),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                        child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 8),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.timer_rounded,
                                                    size: 24,
                                                    color: Colors.indigo,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 5, 0),
                                                    child: Text(
                                                      'Duration',
                                                      style: GoogleFonts.nunito(
                                                        textStyle:
                                                            const TextStyle(
                                                          color: Colors.indigo,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '0:32',
                                                style: GoogleFonts.nunito(
                                                  textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 35,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'min',
                                                style: GoogleFonts.nunito(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xff777586),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                                const Divider(
                                  height: 15,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.square_list,
                                        size: 24,
                                        color: Colors.indigo,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        child: Text(
                                          'Notes',
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Colors.indigo,
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
                                  //Overflow text pushes to next line
                                  child: Text(
                                    'Toni cemuso hite ataneda tebe bigeric lu ire yama sorov! Gew dipebor natasum sikit afahar! Coticol xosieric uladu redes! Cedet ricak secadep bebeni yibas renacab rie: Badi let reri lareri bat asacubes paritur vagone iegarat! Nelalir cof odesie cipir sucomer si. Vaso foreca tunietec toconel ha gi ragi no! Leconug ida tewat febase arerotoh pit peceral. Figare temusa fig redo mesu nec neme wocies. Sef irahote sihelom. Ulurexi zepe na seniep enedico pop hohe renalis dicis.',
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
                                  height: 20,
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.05 * width, 0, 0, 0),
                    child: const Text(
                      'Test Graphs',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'DMSans-Bold',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Center(
                      child: Card(
                        color: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                          width: width * 0.9,
                          height: 600,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(22.0, 20, 22.0, 0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const []),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])));
  }
}
