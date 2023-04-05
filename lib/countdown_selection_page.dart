import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountdownSelectionPage extends StatefulWidget {
  const CountdownSelectionPage({Key? key}) : super(key: key);

  @override
  State<CountdownSelectionPage> createState() => _CountdownSelectionPageState();
}

class _CountdownSelectionPageState extends State<CountdownSelectionPage> {
  //VARIABLES
  final controller = ScrollController();

  final Future<SharedPreferences> futurePrefs = SharedPreferences.getInstance();
  late Future<int> futureCountdownTime;

  //METHODS
  @override
  void initState() {
    super.initState();
    futureCountdownTime = futurePrefs.then((SharedPreferences prefs) {
      return prefs.getInt('countdown') ?? 5;
    });
  }

  setCountdown(int time) async {
    final SharedPreferences prefs = await futurePrefs;

    setState(() {
      futureCountdownTime = prefs.setInt('countdown', time).then((bool success) {
        return time;
      });
    });
  }

//UI

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xfff2f1f6),
      appBar: AppBar(
        leading: GestureDetector(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 32,
            ),
          ]),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        toolbarHeight: 0.06 * height,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            'Countdown',
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
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: FutureBuilder<int>(
                    future: futureCountdownTime,
                    builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CupertinoListSection.insetGrouped(
                              footer: Padding(
                                padding: EdgeInsets.fromLTRB(0.02 * width, 0, 0.02 * width, 0),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 3, 0),
                                      child: Icon(
                                        CupertinoIcons.info,
                                        size: 16,
                                        color: Color(0xffa4a3aa),
                                      )),
                                  Flexible(
                                    child: Text(
                                      'Tap on the countdown timer in the recording page to skip the countdown',
                                      style: TextStyle(fontSize: 15, color: Color(0xffa4a3aa)),
                                    ),
                                  )
                                ]),
                              ),
                              children: [
                                ...[5, 10, 15, 20, 30, 45, 60, 120].map((time) {
                                  int minutes = (time / 60).round();
                                  String minuteFormat;
                                  if (minutes == 1) {
                                    minuteFormat = 'minute';
                                  } else {
                                    minuteFormat = 'minutes';
                                  }
                                  return CupertinoListTile(
                                    title: (time > 59) ? Text('$minutes $minuteFormat') : Text('$time seconds'),
                                    trailing: snapshot.data == time
                                        ? const Icon(
                                            CupertinoIcons.check_mark,
                                            color: Color(0xff006CC6),
                                          )
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        setCountdown(time);
                                      });
                                    },
                                  );
                                }).toList(),
                              ],
                            );
                          }
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
