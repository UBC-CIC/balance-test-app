import 'package:balance_test/TestDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class PastTests extends StatefulWidget {
  const PastTests({Key? key, required this.parentCtx}) : super(key: key);

  final BuildContext parentCtx;

  @override
  State<PastTests> createState() => _PastTestsState();
}

class _PastTestsState extends State<PastTests> {
  //VARIABLES

  final controller = ScrollController();

  List<Test> testList = getTests();

  static List<Test> getTests() {
    const data = [
      {
        "testID": "1", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "Feb 3, 2023 1:40 pm",
        "score": 78,
      },
      {
        "testID": "2", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "Jan 28, 2023 2:26 pm",
        "score": 55,
      },
      {
        "testID": "3", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "Jan 26, 2023 12:45 pm",
        "score": 88,
      },
      {
        "testID": "4", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "Jan 22, 2023 3:02 pm",
        "score": 95,
      },
      {
        "testID": "5", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "Jan 18, 2023 4:30 pm",
        "score": 92,
      },
      {
        "testID": "6", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "Jan 14, 2023 12:02 pm",
        "score": 42,
      },
      {
        "testID": "7", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "Jan 12, 2023 10:29 am",
        "score": 53,
      },
      {
        "testID": "8", //UUID format
        "movement": "sit-to-stand",
        "dateTime": "Jan 8, 2023 11:02 am",
        "score": 85,
      },
    ];

    return data.map<Test>(Test.fromJson).toList();
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


  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Widget buildTestList(List<Test> tests) => ListView.builder(
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
                        // Shows selected item as label

                        // selectedValue = value as String;
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
                    offset: Offset(-0.225*width, 0),
                  ),
                ),
              ),
            );
          } else {

            final test = tests[index - 1];
            final bool dangerScore = test.score<60; //to choose color of score
            return Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                child: Center(
                  child: Card(
                    color: const Color(0xffffffff),
                    elevation: 2,
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
                                             color: dangerScore? Colors.deepOrange : Colors.black,
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
                                          convertMovementName(test.movement),
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              color: Color(0xff2A2A2A),
                                              fontSize: 28,
                                              fontWeight: FontWeight.w600,
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
                                                  test.dateTime,
                                                  style: GoogleFonts.nunito(
                                                    textStyle: const TextStyle(
                                                      color: Color(0xff006CC6),
                                                      fontFamily:
                                                          'DMSans-Medium',
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
                              child: ElevatedButton(
                                onPressed: () {
                                  Gaimon.selection();
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    elevation: 0,
                                    backgroundColor: const Color(0xff006CC6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(0.08 * width),
                                      //border radius equal to or more than 50% of width
                                    )),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 0.07 * width,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          }
        });

    return Expanded(
          child: buildTestList(testList)
    );
  }

  String convertMovementName(String movement) {
    if (movement == "sit-to-stand") {
      // return "Sitting with\nBack Unsupported\nFeet Supported";
      return "Sit to Stand";
    } else {
      return "movement";
    }
  }
}
