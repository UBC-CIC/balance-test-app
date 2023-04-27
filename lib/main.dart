import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'ClinicApp.dart';
import 'PatientApp.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:balance_test/models//ModelProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Main',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PageRouter(title: 'App Router'),
    );
  }
}

//Page Router

class PageRouter extends StatefulWidget {
  const PageRouter({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  //VARIABLES

  final controller = ScrollController();
  Map<String, String> authInfo = {};

  //FUNCTIONS

  @override
  void initState() {
    super.initState();
    _checkUserSignIn();
  }

  Future<void> _checkUserSignIn() async {
    await _configureAmplify();
    StreamSubscription hubSubscription = Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
      print(hubEvent.eventName);
      switch (hubEvent.eventName) {
        case "SIGNED_IN":
          {
            initNotSignedIn();
          }
          break;
        case "SIGNED_OUT":
          {}
          break;
        case "SESSION_EXPIRED":
          {}
          break;
      }
    });
    AuthSession result = await Amplify.Auth.fetchAuthSession();
    if (result.isSignedIn) {
      initSignedIn();
    }
  }

  Future<void> initNotSignedIn() async {
    //Get user group
    AuthSession authSession = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    String token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    String userGroup;
    if(payload['cognito:groups']!=null) {
      userGroup = payload['cognito:groups'][0];
    } else {
      userGroup = '';
    }
    //Wait for user group to be assigned if not already assigned
    int counter = 0;
    while (userGroup != 'patient' && userGroup != 'careProvider') {
      if (counter < 10) {
        await Future.delayed(const Duration(seconds: 1));
        authSession = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true),
        );
        token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
        payload = Jwt.parseJwt(token);
        if(payload['cognito:groups']!=null) {
          userGroup = payload['cognito:groups'][0];
        } else {
          userGroup = '';
        }
        counter++;
      } else {
        await Amplify.Auth.signOut();
        break;
      }
    }
    //Fetch identity_id, assign to Cognito custom attributes if not already assigned
    final cognitoAttributes = await Amplify.Auth.fetchUserAttributes();
    bool containsIdentityId = false;
    for (AuthUserAttribute attribute in cognitoAttributes) {
      if (attribute.userAttributeKey.key == 'custom:identity_id' && attribute.value.isNotEmpty && attribute.value != 'null') {
        containsIdentityId = true;
      }
    }
    if (containsIdentityId == false) {
      final authSession = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      String identityId = (authSession as CognitoAuthSession).identityId!;
      try {
        await Amplify.Auth.updateUserAttribute(
          userAttributeKey: const CognitoUserAttributeKey.custom('identity_id'),
          value: identityId.split(":")[1],
        );
      } on AmplifyException catch (e) {
        if (kDebugMode) {
          print(e.message);
        }
      }
    }
    //Fetch attributes, add patient to patient table if patient user, and route to Patient App or Clinic App
    final Map<String, String> userAttributes = await fetchCurrentUserAttributes();
    if (userGroup == 'patient') {
      try {
        var query = '''
            mutation MyMutation2 {
              createPatient(patient_id: "${userAttributes['custom:identity_id']}", email: "${userAttributes['email']}", first_name: "${userAttributes['given_name']}", last_name: "${userAttributes['family_name']}") {
                email
                first_name
                last_name
                patient_id
              }
            }
          ''';

        final response = await Amplify.API
            .query(request: GraphQLRequest<String>(document: query, variables: {'patient_id': "${userAttributes['custom:identity_id']}"}))
            .response;

        if (response.data == null) {
          if (kDebugMode) {
            print('errors: ${response.errors}');
          }
          await Amplify.Auth.signOut();
        } else {
          if (kDebugMode) {
            print(response.data);
          }
        }
      } on ApiException catch (e) {
        if (kDebugMode) {
          print('Query failed: $e');
        }
      }
      if (context.mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => PatientApp(
              userAttributes: userAttributes,
            ),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ),
        );
      }
    } else if (userGroup == 'careProvider' && context.mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ClinicApp(
            userAttributes: userAttributes,
          ),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ),
      );
    }
  }

  Future<void> initSignedIn() async {
    //Fetch user group
    AuthSession authSession = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    String token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
    // Parse the JWT
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    // Access the groups
    String userGroup;
    if(payload['cognito:groups']!=null) {
      userGroup = payload['cognito:groups'][0];
    } else {
      userGroup = '';
    }
    //Wait for user group to be assigned
    int counter = 0;
    while (userGroup != 'patient' && userGroup != 'careProvider') {
      if (counter < 10) {
        await Future.delayed(const Duration(seconds: 1));
        authSession = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true),
        );
        token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
        payload = Jwt.parseJwt(token);
        if(payload['cognito:groups']!=null) {
          userGroup = payload['cognito:groups'][0];
        } else {
          userGroup = '';
        }
        counter++;
      } else {
        await Amplify.Auth.signOut();
        break;
      }
    }
    //Route to Patient App or Clinic App
    final Map<String, String> userAttributes = await fetchCurrentUserAttributes();
    if (userGroup == 'patient') {
      if (context.mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => PatientApp(
              userAttributes: userAttributes,
            ),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ),
        );
      }
    } else if (userGroup == 'careProvider' && context.mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => ClinicApp(
            userAttributes: userAttributes,
          ),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ),
      );
    }
  }

  Future<bool> _configureAmplify() async {
    final api = AmplifyAPI(modelProvider: ModelProvider.instance, authProviders: const [CustomFunctionProvider()]);
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.addPlugin(AmplifyStorageS3());
      await Amplify.addPlugin(api);
      await Amplify.configure(amplifyconfig);
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print('Error configuring Amplify: $e');
      }
      return false;
    }
  }

  Future<Map<String, String>> fetchCurrentUserAttributes() async {
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
  }

  //UI

  @override
  Widget build(BuildContext mainCtx) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Authenticator(
// builder used to show a custom sign in and sign up experience
        authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
          const padding = EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16);
          switch (state.currentStep) {
            case AuthenticatorStep.signIn:
              return Scaffold(
                body: Padding(
                  padding: padding,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // app logo
                        Padding(padding: const EdgeInsets.fromLTRB(0, 28, 50, 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/BalanceTestIcon.png',
                                width: 100,
                                height: 100,
                              ),
                              const Text(
                                'Balance\nTest',
                                style: TextStyle(
                                  // color: Color.fromRGBO(141, 148, 162, 1.0),
                                  color: Colors.black,
                                  fontFamily: 'DMSans-Regular',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                        Padding(padding: const EdgeInsets.fromLTRB(0, 28, 50, 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/BalanceTestIcon.png',
                                width: 100,
                                height: 100,
                              ),
                              const Text(
                                'Balance\nTest',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'DMSans-Regular',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
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
          debugShowCheckedModeBanner:false,
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
            body: Center(
              child: Image.asset(
                'assets/BalanceTestIcon.png',
                width: 200,
                height: 200,
              ),
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
    return token;
  }
}
