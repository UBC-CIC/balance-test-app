import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:balance_test/account_page.dart';
import 'package:balance_test/home_page.dart';
import 'package:balance_test/past_tests_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'amplifyconfiguration.dart';

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
  bool _amplifyConfigured = false;
  Map<String, String> authInfo = {};

  //FUNCTIONS

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      print('Successfully configured');
      setState(() {
        _amplifyConfigured = true;
      });
      return true;
    } on Exception catch (e) {
      print('Error configuring Amplify: $e');
      return false;
    }
  }

  //UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    Future<Map<String, String>> fetchCurrentUserAttributes() async {
      if (authInfo.isEmpty) {
        final result = await Amplify.Auth.fetchUserAttributes();
        final data = {for (var e in result) e.userAttributeKey.key: e.value};
        authInfo = data;
        return data;
      } else {
        return authInfo;
      }
    }

    List<Widget> pages = <Widget>[
      FutureBuilder<Map<String, String>>(
          future: fetchCurrentUserAttributes(),
          // function where you call your api
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, String>> snapshot) {
            print(snapshot.data);
            return HomePage(
                parentCtx: context,
                userID: (snapshot.data != null) ? snapshot.data!['sub']! : "");
          }),
      const Icon(
        Icons.show_chart_rounded,
        size: 150,
      ),
      FutureBuilder<Map<String, String>>(
          future: fetchCurrentUserAttributes(),
          // function where you call your api
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, String>> snapshot) {
            print(snapshot.data);
            return PastTests(
                parentCtx: context,
                userID: (snapshot.data != null) ? snapshot.data!['sub']! : "");
          }),
      FutureBuilder<Map<String, String>>(
          future: fetchCurrentUserAttributes(),
          // function where you call your api
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, String>> snapshot) {
            print(snapshot.data);
            return AccountPage(
              parentCtx: context,
              givenName:
                  (snapshot.data != null) ? snapshot.data!['given_name']! : "",
              familyName:
                  (snapshot.data != null) ? snapshot.data!['family_name']! : "",
              userID: (snapshot.data != null) ? snapshot.data!['sub']! : "",
              email: (snapshot.data != null) ? snapshot.data!['email']! : "",
            );
          }),
    ];

    const List<String> titles = <String>[
      'Home',
      'Analytics',
      'Past Tests',
      'Account',
    ];

    return Authenticator(
// builder used to show a custom sign in and sign up experience
        authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
          const padding =
              EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 16);
          switch (state.currentStep) {
            case AuthenticatorStep.signIn:
              return Scaffold(
                body: Padding(
                  padding: padding,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // app logo
                        const Center(child: FlutterLogo(size: 100)),
                        // prebuilt sign in form from amplify_authenticator package
                        SignInForm(),
                      ],
                    ),
                  ),
                ),
                // custom button to take the user to sign up
                persistentFooterButtons: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () => state.changeStep(
                          AuthenticatorStep.signUp,
                        ),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              );
            case AuthenticatorStep.signUp:
              return Scaffold(
                body: Padding(
                  padding: padding,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // app logo
                        const Center(child: FlutterLogo(size: 100)),
                        // prebuilt sign up form from amplify_authenticator package
                        SignUpForm(),
                      ],
                    ),
                  ),
                ),
                // custom button to take the user to sign in
                persistentFooterButtons: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () => state.changeStep(
                          AuthenticatorStep.signIn,
                        ),
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              );
            default:
              // returning null defaults to the prebuilt authenticator for all other steps
              return null;
          }
        },
        child: MaterialApp(
          // set the default theme
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo,
              backgroundColor: Colors.white,
            ),
          ).copyWith(
            indicatorColor: Colors.red,
          ),

          builder: Authenticator.builder(),

          home: Scaffold(
            backgroundColor: const Color(0xfff2f1f6),
            appBar: AppBar(
              toolbarHeight:
                  (_selectedIndex == 3) ? 0.06 * height : 0.1 * height,
              centerTitle: (_selectedIndex == 3) ? true : false,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness:
                    Brightness.light, // light for black status bar
              ),
              title: Padding(
                padding: EdgeInsets.fromLTRB(
                    (_selectedIndex == 3) ? 0 : 0.01 * width,
                    (_selectedIndex == 3) ? 0 : 0.1 * width,
                    0,
                    0),
                child: Text(
                  titles.elementAt(_selectedIndex),
                  style: TextStyle(
                    // color: Color.fromRGBO(141, 148, 162, 1.0),
                    color: Colors.black,
                    fontFamily: 'DMSans-Regular',
                    fontSize:
                        (_selectedIndex == 3) ? 0.06 * width : 0.09 * width,
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
        ));
  }
}
