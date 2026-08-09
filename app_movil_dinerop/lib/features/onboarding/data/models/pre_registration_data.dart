class PreRegistrationData {
  const PreRegistrationData({
    required this.firstName,
    required this.lastName,
    required this.identification,
    required this.phone,
    required this.email,
    required this.province,
    required this.city,
  });

  final String? firstName;
  final String? lastName;
  final String? identification;
  final String? phone;
  final String? email;
  final String? province;
  final String? city;

  factory PreRegistrationData.fromJson(Map<String, dynamic> json) {
    return PreRegistrationData(
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      identification: json['identification']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      province: json['province']?.toString(),
      city: json['city']?.toString(),
    );
  }
}