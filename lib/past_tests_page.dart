import 'package:balance_test/TestDetailsListItem.dart';
import 'package:balance_test/test_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';


class PastTests extends StatefulWidget {
  const PastTests({Key? key, required this.parentCtx, required this.userID}) : super(key: key);

  final BuildContext parentCtx;
  final String userID;

  @override
  State<PastTests> createState() => _PastTestsState();
}

class _PastTestsState extends State<PastTests> {
  //VARIABLES

  final controller = ScrollController();

  List<TestDetails> testList = getTests();

  static List<TestDetails> getTests() {
    const data = [
      {
        "testID": "1", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "2023-02-10 15:14:40.731703 -08:00",
        "score": 72,
      },
      {
        "testID": "2", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "2023-02-10 15:17:23.731703 -08:00",
        "score": 55,
      },
      {
        "testID": "3", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "2023-02-18 00:12:32.731703 -08:00",
        "score": 88,
      },
      {
        "testID": "4", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "2022-12-19 12:12:41.731703 -08:00",
        "score": 92,
      },
      {
        "testID": "5", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "2022-10-19 11:12:40.731703 -08:00",
        "score": 92,
      },
      {
        "testID": "6", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "2022-08-12 01:12:22.731703 -08:00",
        "score": 38,
      },
      {
        "testID": "7", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "2022-08-12 01:12:13.731703 -08:00",
        "score": 53,
      },
      {
        "testID": "8", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "2023-01-08 01:19:45.731703 -08:00",
        "score": 85,
      },
    ];

    List<TestDetails> testList = data.map<TestDetails>(TestDetails.fromJson).toList();
    testList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    testList = List.from(testList.reversed);
    return testList;
  }

  void sortList(String? value) {
    if (value == 'Most Recent') {
      testList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      testList = List.from(testList.reversed);
    } else if (value == 'Oldest') {
      testList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    } else if (value == 'Score: Low to High') {
      testList.sort((a, b) => a.score.compareTo(b.score));
    } else if (value == 'Score: High to Low') {
      testList.sort((a, b) => a.score.compareTo(b.score));
      testList = List.from(testList.reversed);
    } else if (value == 'Movement Name: Z to Z') {
      testList.sort((a, b) => a.movement.compareTo(b.movement));
    } else if (value == 'Movement Name: A to Z') {
      testList.sort((a, b) => a.movement.compareTo(b.movement));
      testList = List.from(testList.reversed);
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

  //Dropdown index
  String? selectedValue;

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
      return Colors.black;
    } else if (score < 90) {
      // return const Color(0xff009E9D);
      return Colors.black;
    } else {
      // return const Color(0xff05A985);
      return Colors.black;
    }
  }

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Widget buildTestList(List<TestDetails> tests) => ListView.builder(
        itemCount: tests.length + 1, // To include dropdown as 1st element
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0.05 * width, 0),
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
                                fontSize: 0.0435 * width,
                                color: const Color(0xff006CC6),
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
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        sortList(value);
                      });
                    },
                    icon: const Icon(
                      CupertinoIcons.down_arrow,
                    ),
                    iconSize: 0.0435 * width,
                    iconEnabledColor: const Color(0xff006CC6),
                    iconDisabledColor: Colors.grey,
                    buttonHeight: 0.0966 * width,
                    buttonWidth: 0.26 * width,
                    buttonPadding: EdgeInsets.only(
                        left: 0.02 * width, right: 0.02 * width),
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
                          testID: test.testID, 
                          movementName: formatMovementName(test.movement), 
                          dateFormatted: formatDateTime(test.dateTime), 
                          score: test.score,
                        )));
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                child: Center(
                  child: Card(
                    color: const Color(0xffffffff),
                    elevation: 0,
                    shadowColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
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
                              Container(
                                alignment: Alignment.center,
                                width: 0.18 * width,
                                height: 70,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          test.score.toString(),
                                          style: GoogleFonts.nunito(
                                            textStyle: TextStyle(
                                              color: getScoreColor(test.score),
                                              fontFamily: 'DMSans-Medium',
                                              fontSize: 35,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '%',
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Color(0xff777586),
                                              fontFamily: 'DMSans-Medium',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(14.0, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: 0.42 * width,
                                      height: 60,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          formatMovementName(test.movement),
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Color(0xff2A2A2A),
                                              fontSize: 26,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                                color: Color(0xff006CC6),
                                                size: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        6, 0, 0, 0),
                                                child: Text(
                                                  formatDateTime(test.dateTime),
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                      color: Color(0xff006CC6),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
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
        });

    return Expanded(child: buildTestList(testList));
  }

  String formatMovementName(String movement) {
    if (movement == "sit-to-stand") {
      // return "Sitting with\nBack Unsupported\nFeet Supported";
      return "Sit to Stand";
    } else {
      return "movement";
    }
  }

  String formatDateTime(String dateTimeStr) {
    DateTime newDateTimeObj = DateTime.parse(dateTimeStr);
    return DateFormat("MMM d, y h:mm a").format(newDateTimeObj);
  }
}
