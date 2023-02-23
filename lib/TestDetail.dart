
class TestDetails {
  final String movement;
  final String dateTime;
  final int score;
  final int duration;
  final String notes;

  const TestDetails({
    required this.movement,
    required this.dateTime,
    required this.score,
    required this.duration,
    required this.notes,
  });

  static TestDetails fromJson(json) => TestDetails(
        movement: json['movement'],
        dateTime: json['dateTime'],
        score: json['score'],
        duration: json['duration'],
        notes: json['notes'],
      );

}
