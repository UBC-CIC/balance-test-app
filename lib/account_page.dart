import 'package:balance_test/recording_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_fading_scrollview.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key, required this.parentCtx}) : super(key: key);

  final BuildContext parentCtx;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  //VARIABLES

  //Controller for fading scroll view
  final controller = ScrollController();

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Expanded(
      child: SingleChildScrollView(
        controller: controller,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0.0 * width, 0, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0.015 * height, 0, 0),
                        child: Icon(
                          Icons.account_circle,
                          color: const Color(0xff929292),
                          size: 0.25 * width,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0.0 * height, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 0.8 * width,
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'John Doe',
                              style: TextStyle(
                                fontFamily: 'DMSans-Medium',
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          SafeArea(
            child: SingleChildScrollView(
              child: CupertinoListSection.insetGrouped(
                children: const [

                  CupertinoListTile(title: Text('Simple tile')),
                  CupertinoListTile(
                    title: Text('Title of the tile'),
                    subtitle: Text('Subtitle of the tile'),
                  ),
                  CupertinoListTile(
                    title: Text('With additional info'),
                    additionalInfo: Text('Info'),
                  ),
                  CupertinoListTile(
                    title: Text('With leading & trailing'),
                    leading: Icon(CupertinoIcons.add_circled_solid),
                    trailing: Icon(CupertinoIcons.chevron_forward),
                  ),
                  CupertinoListTile(
                    title: Text('Different background color'),
                    backgroundColor: CupertinoColors.activeGreen,
                  ),
                ],
              ),
            ),
          ),

                ])),
      ),
    );
  }
}
