class PublicRegistrationRequest {
  const PublicRegistrationRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.identification,
    this.phone,
    this.province,
    this.city,
  });

  final String email;
  final String firstName;
  final String lastName;
  final String identification;
  final String? phone;
  final String? province;
  final String? city;

  Map<String, dynamic> toJson() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'identification': identification,
        'phone': phone,
        'province': province,
        'city': city,
      };
}