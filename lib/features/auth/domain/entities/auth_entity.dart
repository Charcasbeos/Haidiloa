class AuthEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime created_at;
  // final DateTime last_sigin_at;

  const AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.created_at,
  });
}
