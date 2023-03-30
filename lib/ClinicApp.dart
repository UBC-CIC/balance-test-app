import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'account_page.dart';
import 'clinic_home_page.dart';

class ClinicApp extends StatefulWidget {
  const ClinicApp({required this.userAttributes, Key? key, this.title}) : super(key: key);

  final String? title;
  final Map<String, String> userAttributes;

  @override
  State<ClinicApp> createState() => _ClinicAppState();
}

class _ClinicAppState extends State<ClinicApp> {
  //VARIABLES

  final controller = ScrollController();

  int _selectedIndex = 0; //NavBar index
  bool _amplifyConfigured = false;
  Map<String, String> authInfo = {};

  //FUNCTIONS

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //UI

  @override
  Widget build(BuildContext mainCtx) {
    double height = MediaQuery.of(mainCtx).size.height;
    double width = MediaQuery.of(mainCtx).size.width;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    List<Widget> pages = <Widget>[
      ClinicHomePage(
        parentCtx: mainCtx,
        userID: widget.userAttributes['custom:identity_id']!,
      ),
      AccountPage(
        parentCtx: mainCtx,
        givenName: widget.userAttributes['given_name']!,
        familyName: widget.userAttributes['family_name']!,
        userID: widget.userAttributes['custom:identity_id']!,
        email: widget.userAttributes['email']!,
      ),
    ];

    const List<String> titles = <String>[
      'Patients',
      'Account',
    ];

    return MaterialApp(
      // set the default theme
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          backgroundColor: Colors.white,
        ),
      ).copyWith(
        indicatorColor: Colors.red,
      ),

      home: Scaffold(
        backgroundColor: const Color(0xfff2f1f6),
        appBar: AppBar(
          toolbarHeight: (_selectedIndex == 1) ? 0.06 * height : 0.1 * height,
          centerTitle: (_selectedIndex == 1) ? true : false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light, // light for black status bar
          ),
          title: Padding(
            padding: EdgeInsets.fromLTRB((_selectedIndex == 1) ? 0 : 0.01 * width, (_selectedIndex == 1) ? 0 : 0.1 * width, 0, 0),
            child: Text(
              titles.elementAt(_selectedIndex),
              style: TextStyle(
                // color: Color.fromRGBO(141, 148, 162, 1.0),
                color: Colors.black,
                fontFamily: (_selectedIndex == 1) ? 'DMSans-Regular' : 'DMSans-Medium',
                fontSize: (_selectedIndex == 1) ? 0.06 * width : 0.085 * width,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(children: [
          pages.elementAt(_selectedIndex), //New
        ]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xfff3f3f2),
          type: BottomNavigationBarType.fixed,
          // Fix for >4 item navbar
          enableFeedback: true,
          unselectedItemColor: const Color(0xff929292),
          selectedItemColor: const Color(0xff006CC6),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 30,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_rounded),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Calls',
            ),
          ],
        ),
      ),
    );
  }
}
