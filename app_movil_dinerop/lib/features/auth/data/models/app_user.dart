enum AppUserRole { client, cooperative, admin, unknown }
enum AppUserStatus { pendingActivation, active, blocked, unknown }

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
  });

  final int id;
  final String email;
  final AppUserRole role;
  final AppUserStatus status;

  bool get isClient => role == AppUserRole.client;
  bool get isActive => status == AppUserStatus.active;
  bool get isPendingActivation => status == AppUserStatus.pendingActivation;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] as num).toInt(),
      email: (json['email'] ?? '').toString(),
      role: _roleFromString(json['role']?.toString()),
      status: _statusFromString(json['status']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'email': email,
        'role': role.name.toUpperCase(),
        'status': status.name.toUpperCase(),
      };

  static AppUserRole _roleFromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'client':
        return AppUserRole.client;
      case 'cooperative':
        return AppUserRole.cooperative;
      case 'admin':
        return AppUserRole.admin;
      default:
        return AppUserRole.unknown;
    }
  }

  static AppUserStatus _statusFromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'PENDING_ACTIVATION':
        return AppUserStatus.pendingActivation;
      case 'ACTIVE':
        return AppUserStatus.active;
      case 'BLOCKED':
        return AppUserStatus.blocked;
      default:
        return AppUserStatus.unknown;
    }
  }
}