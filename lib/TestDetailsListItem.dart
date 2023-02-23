

class TestDetails {
  final String testID;
  final String movement;
  final String dateTime;
  final int score;

  const TestDetails({
    required this.testID,
    required this.movement,
    required this.dateTime,
    required this.score,
  });

  static TestDetails fromJson(json) => TestDetails(
        testID: json['testID'],
        movement: json['movement'],
        dateTime: json['dateTime'],
        score: json['score'],
      );

}
