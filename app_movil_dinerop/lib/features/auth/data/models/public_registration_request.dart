class PublicRegistrationRequest {
  const PublicRegistrationRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.identification,
    required this.phone,
    required this.province,
    required this.city,
    required this.amount,
    required this.plazoMeses,
    required this.creditType,
  });

  final String email;
  final String firstName;
  final String lastName;
  final String identification;
  final String phone;
  final String province;
  final String city;
  final num amount;
  final int plazoMeses;
  final String creditType;

  Map<String, dynamic> toJson() => {
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'identification': identification,
    'phone': phone,
    'province': province,
    'city': city,
    'amount': amount,
    'plazoMeses': plazoMeses,
    'type': 'CREDITO',
    'creditType': creditType,
  };
}
