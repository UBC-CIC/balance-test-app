import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'loading_page.dart';
import 'package:gaimon/gaimon.dart';

import 'my_fading_scrollview.dart';

class CountdownSelectionPage extends StatefulWidget {
  const CountdownSelectionPage({Key? key})
      : super(key: key);


  @override
  State<CountdownSelectionPage> createState() => _CountdownSelectionPageState();
}

class _CountdownSelectionPageState extends State<CountdownSelectionPage> {
  //VARIABLES
  final controller = ScrollController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _countdownTime;

  //METHODS
  @override
  void initState() {
    super.initState();
    _countdownTime = _prefs.then((SharedPreferences prefs) {
      return prefs.getInt('countdown') ?? 5;
    });
  }

  setCountdown(int time) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _countdownTime = prefs.setInt('countdown', time).then((bool success) {
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
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
              'Recording Countdown',
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
                      child:
                      FutureBuilder<int>(
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
                                  return CupertinoListSection.insetGrouped(
                                    children: [
                                      ...[5, 10, 15, 20, 30, 45, 60].map((time) {
                                        return CupertinoListTile(
                                          title: Text('$time seconds'),
                                          trailing: snapshot.data == time ? const Icon(CupertinoIcons.check_mark,
                                            color: Color(0xff007AFF),) : null,
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
                ])));
  }
}
