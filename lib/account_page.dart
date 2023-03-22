import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:balance_test/change_password_page.dart';
import 'package:balance_test/countdown_selection_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage(
      {Key? key,
      required this.parentCtx,
      required this.givenName,
      required this.familyName,
      required this.userID,
      required this.email
   })
      : super(key: key);

  final BuildContext parentCtx;
  final String givenName;
  final String familyName;
  final String userID;
  final String email;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  //VARIABLES

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _countdownTime;

  late String firstName;
  late String lastName;
  late String userID;
  late String email;

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
      return prefs.getInt('countdown') ?? 5; //default countdown
    });
    firstName = widget.givenName;
    lastName = widget.familyName;
    userID = widget.userID;
    email = widget.email;
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

  void setError(AmplifyException e) async {
    setState(() {
      _error = e;
    });
  }

  Text formatCountdown(int? seconds) {
    if (seconds != null) {
      if (seconds > 59) {
        int minutes = (seconds / 60).round();
        String minuteForamt;
        if (minutes == 1) {
          minuteForamt = 'minute';
        } else {
          minuteForamt = 'minutes';
        }
        return Text('$minutes $minuteForamt');
      } else {
        return Text('$seconds seconds');
      }
    } else {
      return const Text('');
    }
  }

  void signOut() async {
    try {
      await Amplify.Auth.signOut();
      showResult('Signed   Out');
      changeDisplay('SHOW_SIGN_IN');
    } on AmplifyException catch (e) {
      setState(() {
        _error = e;
      });
      print(e);
    }
  }

  void _showUpdatePassword() async {
    changeDisplay('SHOW_UPDATE_PASSWORD');
  }

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Future<Map<String, String>> getUserAttributes() async {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final data = {for (var e in attributes) e.userAttributeKey.key: e.value};
      return data;
    }

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
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$firstName $lastName',
                              style: const TextStyle(
                                fontFamily: 'DMSans-Medium',
                                fontSize: 25,
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
                        header: Padding(
                          padding: EdgeInsets.fromLTRB(0.05 * width, 0, 0, 0),
                          child: const Text(
                            'NAME',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xffa4a3aa)),
                          ),
                        ),
                        children: [
                          CupertinoListTile(
                            title: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('$firstName $lastName'),
                            ),
                            // trailing: const Icon(
                            //   CupertinoIcons.forward,
                            //   color: Color(0xffc4c4c6),
                            //   size: 20,
                            // ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: CupertinoListSection.insetGrouped(
                        header: Padding(
                          padding: EdgeInsets.fromLTRB(0.05 * width, 0, 0, 0),
                          child: const Text(
                            'EMAIL',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xffa4a3aa)),
                          ),
                        ),
                        children: [
                          CupertinoListTile(
                            title: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(email),
                            ),
                            // trailing: const Icon(
                            //   CupertinoIcons.forward,
                            //   color: Color(0xffc4c4c6),
                            //   size: 20,
                            // ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: CupertinoListSection.insetGrouped(
                        header: Padding(
                          padding: EdgeInsets.fromLTRB(0.05 * width, 0, 0, 0),
                          child: const Text(
                            'User ID',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xffa4a3aa)),
                          ),
                        ),
                        children: [
                          CupertinoListTile(
                            title: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(userID),
                            ),

                            // trailing: const Icon(
                            //   CupertinoIcons.forward,
                            //   color: Color(0xffc4c4c6),
                            //   size: 20,
                            // ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: CupertinoListSection.insetGrouped(
                        header: Padding(
                          padding: EdgeInsets.fromLTRB(0.05 * width, 0, 0, 0),
                          child: const Text(
                            'PASSWORD',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xffa4a3aa)),
                          ),
                        ),
                        children: [
                          CupertinoListTile(
                            title: const Text(
                              'Change Password',
                              style: TextStyle(
                                color: Color(0xff006CC6),
                              ),
                            ),
                            // trailing: const Icon(
                            //   CupertinoIcons.forward,
                            //   color: Color(0xffc4c4c6),
                            //   size: 20,
                            // ),
                            onTap: () {
                              Navigator.push(
                                  widget.parentCtx,
                                  //Used to pop to main page instead of home
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangePasswordPage()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: CupertinoListSection.insetGrouped(
                        header: Padding(
                          padding: EdgeInsets.fromLTRB(0.05 * width, 0, 0, 0),
                          child: const Text(
                            'RECORDING SETTINGS',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xffa4a3aa)),
                          ),
                        ),
                        children: [
                          CupertinoListTile(
                            title: const Text('Countdown'),
                            additionalInfo: FutureBuilder<int>(
                                future: _countdownTime,
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        return formatCountdown(snapshot.data);
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
                                          builder: (context) =>
                                              const CountdownSelectionPage()))
                                  .then((value) {
                                setState(() {
                                  _countdownTime =
                                      _prefs.then((SharedPreferences prefs) {
                                    return prefs.getInt('countdown') ??
                                        5; //default countdown
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
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        height: 52,
                        width: 112,
                        child: ElevatedButton(
                          onPressed: signOut,
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xff006CC6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
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
                                      fontSize: 19,
                                      fontWeight: FontWeight.w400,
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
