class Test {
  final String testID;
  final String movement;
  final String dateTime;
  final int score;

  const Test({
    required this.testID,
    required this.movement,
    required this.dateTime,
    required this.score,
  });

  static Test fromJson(json) => Test(
        testID: json['testID'],
        movement: json['movement'],
        dateTime: json['dateTime'],
        score: json['score'],
      );
}
