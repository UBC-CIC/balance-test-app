class PatientListItem {

  final String firstName;
  final String lastName;
  final String? email;
  final String userID;

  const PatientListItem({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userID,
  });

  static PatientListItem fromJson(json) => PatientListItem(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      userID: json['patient_id'],
  );
}