import 'package:intl/intl.dart';

class TestItem {
  final String movement;
  final int duration;

  const TestItem({
    required this.movement,
    required this.duration,
  });

  static TestItem fromJson(json) => TestItem(
        movement: json['movement'],
        duration: json['estimated-duration'],
      );

}
