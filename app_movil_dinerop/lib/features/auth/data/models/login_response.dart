import 'app_user.dart';

class LoginResponse {
  const LoginResponse({required this.accessToken, required this.user});

  final String accessToken;
  final AppUser user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userJson = Map<String, dynamic>.from(json['user'] as Map);
    return LoginResponse(
      accessToken: (json['accessToken'] ?? '').toString(),
      user: AppUser.fromJson(userJson),
    );
  }
}