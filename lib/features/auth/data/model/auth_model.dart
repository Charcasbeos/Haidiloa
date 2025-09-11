import 'package:supabase_flutter/supabase_flutter.dart';

class AuthModel {
  final String id;
  final String email;
  final String phone;
  final DateTime created_at;
  // final DateTime last_sigin_at;

  const AuthModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.created_at,
  });
  factory AuthModel.fromSupabase(User user) {
    return AuthModel(
      id: user.id,
      email: user.email ?? "",
      phone: user.phone ?? "",
      created_at: DateTime.parse(user.createdAt),
    );
  }
}
