class PatientListItem {
  final String name;
  final String email;
  final String userID;

  const PatientListItem({
    required this.name,
    required this.email,
    required this.userID,
  });

  static PatientListItem fromJson(json) => PatientListItem(
    name: json['name'],
    email: json['email'],
    userID: json['userID'],
  );
}