import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  //VARIABLES
  final controller = ScrollController();

  bool allTextFilled = false;

  late TextEditingController currentController;
  late TextEditingController newController;
  late TextEditingController verifyController;

  AmplifyException? _error;

  //METHODS
  @override
  void initState() {
    super.initState();
    currentController = TextEditingController();
    newController = TextEditingController();
    verifyController = TextEditingController();

  }

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    verifyController.dispose();
    super.dispose();
  }

  void updateFilledStatus(String text) {
    if(currentController.text.isNotEmpty && newController.text.isNotEmpty && verifyController.text.isNotEmpty) {
      setState(() {
        allTextFilled = true;
      });
    } else {
      setState(() {
        allTextFilled = false;
      });
    }
  }



//UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Future<void> showNonMatchingAlert(BuildContext context) async {
      return showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Passwords do not match'),
          content: const Text('Enter your new password again.'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              /// This parameter indicates this action is the default,
              /// and turns the action's text to bold text.
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK',
              style: TextStyle(fontWeight: FontWeight.w400),),
            ),
          ],
        ),
      );
    }

    Future<void> showPasswordUpdatedAlert(BuildContext context) async {
      return showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Password Updated'),
          content: const Text('Your password was updated successfully.'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              /// This parameter indicates this action is the default,
              /// and turns the action's text to bold text.
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      );
    }



    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: const Color(0xfff2f1f6),
        appBar: AppBar(
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(
              CupertinoIcons.chevron_back,
              color: Colors.black,
              size: 0.03 * height,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          actions: <Widget>[
             if (allTextFilled) Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0.05 * width, 0),
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.indigo, fontSize: 18),
                ),
                onPressed: () async {
                  if(allTextFilled&& (newController.text!=verifyController.text)) {
                    showNonMatchingAlert(context);
                  } else {
                    try {
                      await Amplify.Auth.updatePassword(
                          newPassword: newController.text.trim(),
                          oldPassword: currentController.text.trim());
                      showPasswordUpdatedAlert(context);
                    } on AmplifyException catch (e) {
                      _error = e;
                      print(_error!.message);
                      print(_error!.recoverySuggestion);
                      print(_error!.underlyingException);
                      print(_error.toString());
                      print(_error.runtimeType);

                    }
                  }
                },
              ),
            )

          ],
          toolbarHeight: 0.06 * height,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              'Password',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  // color: Color.fromRGBO(141, 148, 162, 1.0),
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: const Color(0xfcf2f1f6),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0.05 * width, 0.03*height, 0.05 * width, 0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.fromLTRB(0.06 * width, 8, 0, 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoTextField.borderless(
                  controller: currentController,
                  onChanged: updateFilledStatus,
                  padding:
                      const EdgeInsets.only(left: 20, top: 6, right: 6, bottom: 6),
                  prefix: const Text(
                    'Current',
                    style: TextStyle(fontSize: 16),
                  ),
                  placeholder: 'Required',
                  obscureText: true,
                ),
                const Divider(
                  thickness: 0.5,
                  color: Color(0xffcececf),
                  endIndent: 0,
                ),
                CupertinoTextField.borderless(
                  controller: newController,
                  onChanged: updateFilledStatus,
                  padding:
                      const EdgeInsets.only(left: 45, top: 6, right: 6, bottom: 6),
                  prefix: const Text(
                    'New',
                    style: TextStyle(fontSize: 16),
                  ),
                  placeholder: 'Enter New Password',
                  obscureText: true,
                ),
                const Divider(
                  thickness: 0.5,
                  color: Color(0xffcececf),
                  endIndent: 0,
                ),
                CupertinoTextField.borderless(
                  controller: verifyController,
                  onChanged: updateFilledStatus,
                  padding:
                      const EdgeInsets.only(left: 35, top: 6, right: 6, bottom: 8),
                  prefix: const Text(
                    'Verify',
                    style: TextStyle(fontSize: 16),
                  ),
                  placeholder: 'Re-enter Password',
                  obscureText: true,
                ),
              ],
            ),
          ),
        ));
  }
}
