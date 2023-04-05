import 'package:balance_test/my_folding_cube.dart';
import 'package:flutter/material.dart';
import 'my_animated_check.dart';
import 'package:animated_cross/animated_cross.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key, required this.showCheckmark}) : super(key: key);

  final ValueNotifier showCheckmark;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
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
                  child: ValueListenableBuilder(
                    valueListenable: widget.showCheckmark,
                    builder: (context, value, child) {
                      if (value == 'success') {
                        _animationController.forward();
                        return AnimatedCheck(
                          progress: _animation,
                          size: 110,
                          color: Colors.indigo,
                        );
                      } else if (value == 'failed') {
                        _animationController.forward();
                        return AnimatedCross(
                          progress: _animation,
                          size: 110,
                          color: Colors.redAccent,
                        );
                      } else {
                        return const MyFoldingCube(
                          color: Colors.indigo,
                          size: 50.0,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
