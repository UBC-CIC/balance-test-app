import 'package:balance_test/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //VARIABLES

  final controller = ScrollController();

  int _selectedIndex = 0; //NavBar index

  //FUNCTIONS

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    List<Widget> pages = <Widget>[
      HomePage(parentCtx: context),
      const Icon(
        Icons.show_chart_rounded,
        size: 150,
      ),
      const Icon(
        Icons.menu_rounded,
        size: 150,
      ),
      const Icon(
        Icons.account_circle,
        size: 150,
      ),
    ];

    const List<String> titles = <String>[
      'Home',
      'Analytics',
      'Past Tests',
      'Account',
    ];

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0.1 * height,
          centerTitle: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light, // light for black status bar
          ),
          title: Padding(
            padding: EdgeInsets.fromLTRB(0.05 * width, 0, 0, 0),
            child: Text(
              titles.elementAt(_selectedIndex),
              style: const TextStyle(
                color: Color.fromRGBO(141, 148, 162, 1.0),
                fontFamily: 'DMSans-Medium',
                fontSize: 40,
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
          type: BottomNavigationBarType.fixed,
          // Fix for >4 item navbar
          enableFeedback: true,
          unselectedItemColor: const Color.fromRGBO(203, 203, 203, 1.0),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 30,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_rounded),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_rounded),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Calls',
            ),
          ],
        ),
      ),
    );
  }
}
