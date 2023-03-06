
class TestItem {
  final String movement;
  final int duration;
  final String instructions;

  const TestItem({
    required this.movement,
    required this.duration,
    required this.instructions
  });

  static TestItem fromJson(json) => TestItem(
        movement: json['movement'],
        duration: json['estimated-duration'],
        instructions: json['instructions'],
      );

}
