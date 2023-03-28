import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:balance_test/PatientApp.dart';
import 'package:balance_test/account_page.dart';
import 'package:balance_test/clinic_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'amplifyconfiguration.dart';

import 'package:balance_test/models//ModelProvider.dart';
import 'package:amplify_api/amplify_api.dart';

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
      home: const AppRouter(title: 'Flutter Demo Home Page'),
    );
  }
}

//Patient App

class AppRouter extends StatefulWidget {
  const AppRouter({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  //VARIABLES
  bool isSignedIn = false;

  final controller = ScrollController();

  bool _amplifyConfigured = false;
  Map<String, String> authInfo = {};

  //FUNCTIONS

  @override
  void initState() {
    super.initState();
    _checkUserSignIn();
  }

  Future<void> _checkUserSignIn() async {

    await _configureAmplify();

    AuthSession result = await Amplify.Auth.fetchAuthSession();

    while (!result.isSignedIn) {
      print('CHECKING LOGIN');

      await Future.delayed(const Duration(seconds: 1));
      result = await Amplify.Auth.fetchAuthSession();
    }
    await Future.delayed(const Duration(seconds: 1));


    AuthSession authSession = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    String token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
    // Parse the JWT
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    // Access the groups
    String userGroup = payload['cognito:groups'][0];
    while(userGroup!='patient_user' && userGroup!='care_provider_user') {
      print(userGroup);
      print('CHECKING USER GROUP');
      await Future.delayed(const Duration(seconds: 1));
      authSession = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
      payload = Jwt.parseJwt(token);
      userGroup = payload['cognito:groups'][0];
    }

    print(userGroup);

    final cognitoAttributes = await Amplify.Auth.fetchUserAttributes();
    bool containsIdentityId = false;
    for(AuthUserAttribute attribute in cognitoAttributes){
      print(attribute.userAttributeKey.key);
      if(attribute.userAttributeKey.key == 'custom:identity_id' && attribute.value.isNotEmpty) {
        containsIdentityId = true;
      }
    }
    if(containsIdentityId==false) {
      final authSession = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      String identityId = (authSession as CognitoAuthSession).identityId!;
      try {
        final result = await Amplify.Auth.updateUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.custom('identity_id'),
          value: identityId.split(":")[1],
        );
        if (result.nextStep.updateAttributeStep == 'CONFIRM_ATTRIBUTE_WITH_CODE') {
          var destination = result.nextStep.codeDeliveryDetails?.destination;
          print('Confirmation code sent to $destination');
        } else {
          print('Update completed');
        }
      } on AmplifyException catch (e) {
        print(e.message);
      }
    }




    final Map<String, String> userAttriubtes = await fetchCurrentUserAttributes();
    print(userAttriubtes);
    if(userGroup == 'patient_user' && context.mounted) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PatientApp(userAttributes: userAttriubtes,),
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
      ),

    );
    } else if (userGroup == 'care_provider_user' && context.mounted){
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => PatientApp(userAttributes: userAttriubtes,),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ),

      );
    }
  }


  Future<bool> _configureAmplify() async{
    final api = AmplifyAPI(modelProvider: ModelProvider.instance,
    authProviders: const [CustomFunctionProvider()]);
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyStorageS3());
      await Amplify.addPlugin(api);
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

  Future<Map<String, String>> fetchCurrentUserAttributes() async {
    if (authInfo.isEmpty) {
      print('AUTH INFO EMPTY');
      final result = await Amplify.Auth.fetchUserAttributes();
      final data = {for (var e in result) e.userAttributeKey.key: e.value};
      final authSession = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      String token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
      // Parse the JWT
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      // Access the groups
      String userGroup = payload['cognito:groups'][0];

      authInfo = data;
      authInfo["user_group"] = userGroup;
      return authInfo;
    } else {
      print('AUTH INFO FILLED');
      return authInfo;
    }
  }

  //UI

  @override
  Widget build(BuildContext mainCtx) {
    double height = MediaQuery.of(mainCtx).size.height;
    double width = MediaQuery.of(mainCtx).size.width;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);




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
        child: MaterialApp(// set the default theme
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo,
              backgroundColor: Colors.white,
            ),
          ).copyWith(
            indicatorColor: Colors.red,
          ),

          builder: Authenticator.builder(),
          home: const Scaffold(
            body: Center(
              child: Text('Balance Test',
              style: TextStyle(
                fontFamily: 'DMSans-Medium',
                fontWeight: FontWeight.w600,
                fontSize: 30,
              )),
            ),
          ),
        ));
  }
}






class CustomFunctionProvider extends FunctionAuthProvider {
  const CustomFunctionProvider();

  @override
  Future<String?> getLatestAuthToken() async {
    AuthSession authSession = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    String token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
    print(token);
    return token;
  }
}







// Clinic App

class ClinicApp extends StatefulWidget {
  const ClinicApp({Key? key, this.title}) : super(key: key);

  final String? title;

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
    _configureAmplify();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _configureAmplify() async {
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyStorageS3());
      await Amplify.addPlugin(api);
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
  Widget build(BuildContext mainCtx) {
    double height = MediaQuery.of(mainCtx).size.height;
    double width = MediaQuery.of(mainCtx).size.width;

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
            return ClinicHomePage(
                parentCtx: mainCtx,
                userID: (snapshot.data != null)
                    ? snapshot.data!['identity_id']!
                    : "");
          }),
      FutureBuilder<Map<String, String>>(
          future: fetchCurrentUserAttributes(),
          // function where you call your api
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, String>> snapshot) {
            print(snapshot.data);
            return AccountPage(
              parentCtx: mainCtx,
              givenName:
                  (snapshot.data != null) ? snapshot.data!['given_name']! : "",
              familyName:
                  (snapshot.data != null) ? snapshot.data!['family_name']! : "",
              userID:
                  (snapshot.data != null) ? snapshot.data!['identity_id']! : "",
              email: (snapshot.data != null) ? snapshot.data!['email']! : "",
            );
          }),
    ];

    const List<String> titles = <String>[
      'Patients',
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
                  (_selectedIndex == 1) ? 0.06 * height : 0.1 * height,
              centerTitle: (_selectedIndex == 1) ? true : false,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness:
                    Brightness.light, // light for black status bar
              ),
              title: Padding(
                padding: EdgeInsets.fromLTRB(
                    (_selectedIndex == 1) ? 0 : 0.01 * width,
                    (_selectedIndex == 1) ? 0 : 0.1 * width,
                    0,
                    0),
                child: Text(
                  titles.elementAt(_selectedIndex),
                  style: TextStyle(
                    // color: Color.fromRGBO(141, 148, 162, 1.0),
                    color: Colors.black,
                    fontFamily: (_selectedIndex == 1)
                        ? 'DMSans-Regular'
                        : 'DMSans-Medium',
                    fontSize:
                        (_selectedIndex == 1) ? 0.06 * width : 0.085 * width,
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
        ));
  }
}
