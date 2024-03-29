import 'package:balance_test/clinic_patient_page.dart';
import 'package:balance_test/models/PatientListItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:gaimon/gaimon.dart';
import 'package:google_fonts/google_fonts.dart';


class AlphabetScrollPage extends StatefulWidget {
  const AlphabetScrollPage({
    Key? key,
    required this.patientList,
    required this.parentCtx,
  }) : super(key: key);

  final List<PatientListItem> patientList;
  final BuildContext parentCtx;

  @override
  State<AlphabetScrollPage> createState() => _AlphabetScrollPageState();
}


class _AlphabetScrollPageState extends State<AlphabetScrollPage> {

  List<_AZItem> items = [];

  @override
  void initState() {
    super.initState();
    initList(widget.patientList);
  }

  void initList(List<PatientListItem> items) {
    this.items = items
        .map(
          (item) => _AZItem(
            firstName: item.firstName,
            lastName: item.lastName,
            userID: item.userID,
            tag: item.lastName.isNotEmpty? item.lastName.substring(0,1).toUpperCase() : "",
          ),
        )
        .toList();
    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
  }

  Widget buildHeaderTitle(String tag) => Container(
    height: 42,
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: EdgeInsets.fromLTRB(0.06* MediaQuery.of(context).size.width, 15, 0, 0),
      child: Text(
        tag,
        softWrap: false,
        style: const TextStyle(
          color: Color(0xff929292),
          fontSize: 20,
          fontWeight: FontWeight.w800,
          fontFamily: 'DMSans-Regular',
        ),
      ),),
  );

  @override
  Widget build(BuildContext context) => AzListView(
        padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
        data: items,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return buildListItem(item);
        },
      );

  Widget buildListItem(_AZItem item) {
    double width = MediaQuery.of(context).size.width;

    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;

    return Column(
        children: <Widget>[
          Offstage(offstage:  offstage,
          child: buildHeaderTitle(tag),),
          GestureDetector(
      onTap: () {
        Gaimon.selection();
        Navigator.push(
            widget.parentCtx,
            MaterialPageRoute(
                builder: (context) => ClinicPatientPage(
                    name: "${item.firstName} ${item.lastName}",
                    userID: item.userID)
            )
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
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
              height: 86,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.fromLTRB(0.05*width, 10, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 0.46 * width,
                              height: 38,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "${item.lastName}, ${item.firstName}",
                                  style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                      color: Color(0xff2A2A2A),
                                      fontSize: 22,
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
                                width: 0.7 * width,
                                height: 22,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.account_circle,
                                        color: Color(0xff006CC6),
                                        size: 16,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.fromLTRB(
                                            3, 0, 0, 0),
                                        child: Text(
                                          item.userID,
                                          style: GoogleFonts.nunito(
                                            textStyle: const TextStyle(
                                              // color: Color(0xff006CC6),
                                              fontSize: 14,
                                              fontWeight:
                                              FontWeight.w700,
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
                      height: 0.1 * width,
                      width: 0.1* width,
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
    )
        ],
          );

  }
}





class _AZItem extends ISuspensionBean {
  final String firstName;
  final String lastName;
  final String userID;
  final String tag; //Used to order and group list
  _AZItem({required this.firstName, required this.lastName, required this.userID, required this.tag});

  @override
  String getSuspensionTag() => tag.toString();
}
