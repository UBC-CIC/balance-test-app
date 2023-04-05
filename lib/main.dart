import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
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
    if (result.isSignedIn) {
      initSignedIn();
    }
    StreamSubscription hubSubscription = Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
      print(hubEvent.eventName);
      switch (hubEvent.eventName) {
        case "SIGNED_IN":
          {
            initNotSignedIn();
            print("USER IS SIGNED IN");
          }
          break;
        case "SIGNED_OUT":
          {
            print("USER IS SIGNED OUT");
          }
          break;
        case "SESSION_EXPIRED":
          {
            print("USER IS SIGNED IN");
          }
          break;
      }
    });
  }

  Future<void> initNotSignedIn() async {
    // Wait for user group to be assigned if not assigned

    AuthSession authSession = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    String token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
    // Parse the JWT
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    // Access the groups
    String userGroup = payload['cognito:groups'][0];

    while (userGroup != 'patient_user' && userGroup != 'care_provider_user') {
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

    // Assign identity id to cognito custom attributes if not already assigned

    final cognitoAttributes = await Amplify.Auth.fetchUserAttributes();
    bool containsIdentityId = false;
    for (AuthUserAttribute attribute in cognitoAttributes) {
      print(attribute.userAttributeKey.key);
      if (attribute.userAttributeKey.key == 'custom:identity_id' && attribute.value.isNotEmpty) {
        containsIdentityId = true;
      }
    }
    if (containsIdentityId == false) {
      final authSession = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      String identityId = (authSession as CognitoAuthSession).identityId!;
      try {
        final result = await Amplify.Auth.updateUserAttribute(
          userAttributeKey: const CognitoUserAttributeKey.custom('identity_id'),
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

    // Route to new page

    final Map<String, String> userAttributes = await fetchCurrentUserAttributes();
    print(userAttributes);
    if (userGroup == 'patient_user') {
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
          print('errors: ${response.errors}');
        } else {
          print(response.data);
        }
      } on ApiException catch (e) {
        print('Query failed: $e');
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
    } else if (userGroup == 'care_provider_user' && context.mounted) {
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
    // Wait for user group to be assigned if not assigned

    AuthSession authSession = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    String token = (authSession as CognitoAuthSession).userPoolTokens!.idToken;
    // Parse the JWT
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    // Access the groups
    String userGroup = payload['cognito:groups'][0];

    while (userGroup != 'patient_user' && userGroup != 'care_provider_user') {
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

    final Map<String, String> userAttributes = await fetchCurrentUserAttributes();
    if (userGroup == 'patient_user') {
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
    } else if (userGroup == 'care_provider_user' && context.mounted) {
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
          const padding = EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 16);
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
