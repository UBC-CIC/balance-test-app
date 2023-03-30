
class RangeData {
  final List<int> dayList;
  final List<int> monthList;
  final List<int> yearList;
  final List<double> min;
  final List<double> max;


  const RangeData({
    required this.dayList,
    required this.monthList,
    required this.yearList,
    required this.min,
    required this.max,
  });

  static RangeData fromJson(json) => RangeData(
      dayList: json['day'],
      monthList: json['month'],
      yearList: json['year'],
      min: json['min'],
      max: json['max']
      );

}
