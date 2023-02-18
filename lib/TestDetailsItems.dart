import 'package:intl/intl.dart';

class TestDetailsItem {
  final String testID;
  final String movement;
  final String dateTime;
  final int score;

  const TestDetailsItem({
    required this.testID,
    required this.movement,
    required this.dateTime,
    required this.score,
  });

  static TestDetailsItem fromJson(json) => TestDetailsItem(
        testID: json['testID'],
        movement: json['movement'],
        dateTime: json['dateTime'],
        score: json['score'],
      );

}
