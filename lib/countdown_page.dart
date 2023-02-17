import 'package:balance_test/my_folding_cube.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'my_animated_check.dart';

class CountDown extends StatefulWidget {
  const CountDown({Key? key, required this.countdownDuration}) : super(key: key);

  final int countdownDuration;

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  CountDownController controller = CountDownController();

  @override
  void initState() {
    super.initState();
    controller.start();
  }


  @override
  Widget build(BuildContext context) {
    return
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Center(
                      child: CircularCountDownTimer(
                        duration: widget.countdownDuration,
                        controller: controller,
                        width: 120,
                        height: 120,
                        ringColor: Colors.grey[300]!,
                        fillColor: const Color(0xff006CC6),
                        backgroundColor: Colors.white,
                        strokeWidth: 15.0,
                        textStyle: GoogleFonts.varelaRound(
                          textStyle: const TextStyle(
                            color: Color(0xff2A2A2A),
                            fontSize: 35,
                          ),
                        ),
                        isReverse: true,
                        isReverseAnimation: false,
                        strokeCap: StrokeCap.round,
                        onComplete: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
