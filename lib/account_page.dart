import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:balance_test/countdown_selection_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key, required this.parentCtx}) : super(key: key);

  final BuildContext parentCtx;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  //VARIABLES

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _countdownTime;
  
  //Controller for fading scroll view
  final controller = ScrollController();
  
  AmplifyException? _error;
  String authState = 'User not signed in';
  String displayState = '';

  //FUNCTIONS

  @override
  void initState() {
    super.initState();
    _countdownTime = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('countdown') ?? 5;   //default countdown
    });
  }

  void showResult(_authState) async {
    setState(() {
      _error = null;
      authState = _authState;
    });
    print(authState);
  }

  void changeDisplay(_displayState) async {
    setState(() {
      _error = null;
      displayState = _displayState;
    });
    print(displayState);
  }

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
                  SafeArea(
                    child: SingleChildScrollView(
                      child: CupertinoListSection.insetGrouped(
                        children: [
                          CupertinoListTile(
                            title: const Text('Recording Countdown'),
                            additionalInfo: FutureBuilder<int>(
                                future: _countdownTime,
                                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return Text(
                                          '${snapshot.data} seconds');
                                      }
                                  }
                                }),
                            trailing: const Icon(
                              CupertinoIcons.forward,
                              color: Color(0xffc4c4c6),
                              size: 20,
                            ),
                            onTap: () {
                              Navigator.push(
                                  widget.parentCtx,
                                  //Used to pop to main page instead of home
                                  MaterialPageRoute(
                                      builder: (context) => const CountdownSelectionPage())).then((value) {
                                        setState(() {
                                          _countdownTime = _prefs.then((SharedPreferences prefs) {
                                            return prefs.getInt('countdown') ?? 5;   //default countdown
                                          });
                                        });

                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        height: 60,
                        width: 0.28 * width,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await Amplify.Auth.signOut();
                              showResult('Signed Out');
                              changeDisplay('SHOW_SIGN_IN');
                            } on AmplifyException catch (e) {
                              setState(() {
                                _error = e;
                              });
                              print(e);
                            }
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
                                  'Sign Out',
                                  style: GoogleFonts.nunito(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'DMSans-Medium',
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])),
      ),
    );
  }
}
