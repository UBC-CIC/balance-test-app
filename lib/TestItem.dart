import 'package:intl/intl.dart';

class TestItem {
  final String movement;

  const TestItem({
    required this.movement,
  });

  static TestItem fromJson(json) => TestItem(
        movement: json['movement'],
      );

}
