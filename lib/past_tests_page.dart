import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:balance_test/test_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gaimon/gaimon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'models/TestEvent.dart';

class PastTests extends StatefulWidget {
  const PastTests({Key? key, required this.parentCtx, required this.userID}) : super(key: key);

  final BuildContext parentCtx;
  final String userID;

  @override
  State<PastTests> createState() => _PastTestsState();
}

class _PastTestsState extends State<PastTests> {
  //VARIABLES

  late Future<List<TestEvent>> futureTestList;
  List<TestEvent> testList = [];

  //METHODS

  @override
  void initState() {
    super.initState();
    futureTestList = queryTestEvents();
  }

  Future<List<TestEvent>> queryTestEvents() async {
    try {
      var query = '''
        query MyQuery {
          getTestEvents(patient_id: "${widget.userID}") {
            balance_score
            doctor_score
            notes
            start_time
            end_time
            test_type
            test_event_id
            patient_id
          }
        }
      ''';

      final response = await Amplify.API.query(request: GraphQLRequest<String>(document: query, variables: {'patient_id': widget.userID})).response;

      if (response.data == null) {
        if (kDebugMode) {
          print('errors: ${response.errors}');
        }
        return <TestEvent>[];
      } else {
        final testListJson = json.decode(response.data!);

        List<TestEvent> tempList = [];

        testListJson["getTestEvents"].forEach((entry) {
          tempList.add(TestEvent.fromJson(entry));
        });

        tempList.sort((a, b) => b.start_time!.compareTo(a.start_time!));
        return tempList;
      }
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('Query failed: $e');
      }
    }
    return <TestEvent>[];
  }

  String formatMovementName(String movement) {
    if (movement == "sit-to-stand") {
      // return "Sitting with\nBack Unsupported\nFeet Supported";
      return "Sit to Stand";
    } else {
      return "err";
    }
  }

  String formatDateTime(DateTime dateTimeObj) {
    return DateFormat("MMM d, y h:mm a").format(dateTimeObj);
  }

  void sortList(String? value) {
    if (testList.isNotEmpty) {
      if (value == 'Most Recent') {
        testList.sort((a, b) => b.start_time!.compareTo(a.start_time!));
      } else if (value == 'Oldest') {
        testList.sort((a, b) => a.start_time!.compareTo(b.start_time!));
      } else if (value == 'Score: Low to High') {
        testList.sort((a, b) => (a.balance_score ?? 0).compareTo(b.balance_score ?? 0));
      } else if (value == 'Score: High to Low') {
        testList.sort((a, b) => (b.balance_score ?? 0).compareTo(a.balance_score ?? 0));
      } else if (value == 'Movement Name: Z to Z') {
        testList.sort((a, b) => a.test_type.compareTo(b.test_type));
      } else if (value == 'Movement Name: A to Z') {
        testList.sort((a, b) => b.test_type.compareTo(a.test_type));
      }
    }
  }

  //Dropdown options
  final List<String> items = [
    'Most Recent',
    'Oldest',
    'Score: Low to High',
    'Score: High to Low',
    'Movement Name: A to Z',
    'Movement Name: Z to A',
  ];

  String? dropdownIndex;

  //Adds dividers to list of items in dropdown
  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                // fontFamily: 'DM-Sans-Bold',
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return menuItems;
  }

  //Sets dropdown item heights
  List<double> _getCustomItemsHeights() {
    List<double> itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(50);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  //returns Hex color based on score
  Color getScoreColor(int score) {
    if (score < 40) {
      return const Color(0xffAD2234);
    } else if (score < 65) {
      return Colors.deepOrange;
    } else if (score < 75) {
      return Colors.indigo;
    } else if (score < 90) {
      // return const Color(0xff009E9D);
      return Colors.indigo;
    } else {
      // return const Color(0xff05A985);
      return Colors.indigo;
    }
  }

  Future refresh() async {
    setState(() {
      futureTestList = queryTestEvents();
    });
    await futureTestList;
  }

  //UI

  Widget buildTestList(List<TestEvent> tests) {
    double width = MediaQuery.of(context).size.width;
    if (tests.isEmpty) {
      return const Center(child: Text('No Tests Found'));
    } else {
      return RefreshIndicator(
        color: Colors.indigo,
        onRefresh: refresh,
        child: ListView.builder(
            itemCount: tests.length + 1, // To include dropdown as 1st element
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0.05 * width, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Sort By',
                                  style: TextStyle(
                                    fontSize: 0.04 * width,
                                    color: Colors.indigo,
                                    fontFamily: 'DM-Sans-Medium',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        items: _addDividersAfterItems(items),
                        customItemsHeights: _getCustomItemsHeights(),
                        value: dropdownIndex,
                        onChanged: (value) {
                          setState(() {
                            sortList(value);
                          });
                        },
                        icon: const Icon(
                          CupertinoIcons.down_arrow,
                        ),
                        iconSize: 0.04 * width,
                        iconEnabledColor: Colors.indigo,
                        iconDisabledColor: Colors.grey,
                        buttonHeight: 0.0966 * width,
                        buttonWidth: 0.26 * width,
                        buttonPadding: EdgeInsets.only(left: 0.02 * width, right: 0.02 * width),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          // border: Border.all(
                          //   color: Colors.black26,
                          // ),
                          color: Colors.transparent,
                        ),
                        buttonElevation: 0,
                        itemHeight: 40,
                        itemPadding: const EdgeInsets.only(left: 14, right: 14),
                        dropdownMaxHeight: 200,
                        dropdownWidth: 200,
                        dropdownPadding: null,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                        ),
                        dropdownElevation: 8,
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        offset: Offset(-0.225 * width, 0),
                      ),
                    ),
                  ),
                );
              } else {
                final test = tests[index - 1];

                return GestureDetector(
                  onTap: () {
                    Gaimon.selection();
                    Navigator.push(
                        widget.parentCtx,
                        //Used to pop to main page instead of home
                        MaterialPageRoute(
                            builder: (context) => TestDetailsPage(
                                  testID: test == null ? 'empty' : test.test_event_id,
                                  formattedMovementName: formatMovementName(test == null ? 'empty' : test.test_type),
                                  movementName: test.test_type,
                                  dateFormatted: formatDateTime(test == null ? DateTime.utc(1000, 1, 1) : test.start_time!.getDateTimeInUtc()),
                                  score: test == null ? '204' : (test.balance_score == null ? '-' : test.balance_score.toString()),
                                  notes: test.notes,
                                  dateTimeObj: test.start_time!.getDateTimeInUtc(),
                                  userID: widget.userID,
                                  duration: test.end_time!.getDateTimeInUtc().difference(test.start_time!.getDateTimeInUtc()).inSeconds,
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: Center(
                      child: Card(
                        color: const Color(0xffffffff),
                        elevation: 2,
                        shadowColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: SizedBox(
                          width: width * 0.90,
                          height: 110,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0.04 * width, 0, 0, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffedf0f9),
                                        borderRadius: BorderRadius.all(Radius.circular(0.06 * width)),
                                      ),
                                      alignment: Alignment.center,
                                      width: 0.17 * width,
                                      height: 0.17 * width,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              Text(
                                                test == null ? 'err' : (test.balance_score == null ? '-' : test.balance_score.toString()),
                                                style: GoogleFonts.nunito(
                                                  textStyle: TextStyle(
                                                    color:
                                                        getScoreColor(test == null ? 100 : (test.balance_score == null ? 100 : test.balance_score!)),
                                                    fontFamily: 'DMSans-Medium',
                                                    fontSize: 0.067 * width,
                                                    fontWeight: FontWeight.w700,
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
                                    padding: EdgeInsets.fromLTRB(0.06 * width, 10, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: 0.46 * width,
                                          height: 55,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              formatMovementName(test == null ? 'empty' : test.test_type),
                                              style: GoogleFonts.nunito(
                                                textStyle: const TextStyle(
                                                  color: Color(0xff2A2A2A),
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            width: 0.46 * width,
                                            height: 34,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    CupertinoIcons.calendar,
                                                    color: Colors.indigo,
                                                    size: 20,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                                    child: Text(
                                                      formatDateTime(test == null ? DateTime.utc(1000, 1, 1) : test.start_time!.getDateTimeInUtc()),
                                                      style: GoogleFonts.nunito(
                                                        textStyle: const TextStyle(
                                                          color: Colors.indigo,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: SizedBox(
                                  height: 0.13 * width,
                                  width: 0.13 * width,
                                  child: Icon(
                                    CupertinoIcons.forward,
                                    color: const Color(0xffc4c4c6),
                                    size: 0.06 * width,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<TestEvent>>(
        future: futureTestList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            testList = snapshot.data!;

            return buildTestList(testList);
          } else {
            return const Center(
                child: SpinKitThreeInOut(
              color: Colors.indigo,
              size: 50.0,
            ));
          }
        },
      ),
    );
  }
}
