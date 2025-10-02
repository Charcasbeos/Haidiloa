class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int point;
  final DateTime birthday;
  final String role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.point,
    required this.role,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birthday: DateTime.parse(json['birthday']),
      point: json['point'] ?? 0,
      role: json['role'] ?? 'user',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'birthday': birthday.toIso8601String(),
      'point': point,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'UserModel('
        'id: $id, '
        'name: $name, '
        'email: $email, '
        'phone: $phone, '
        'birthday: $birthday, '
        'point: $point,'
        'role: $role,'
        ')';
  }
}
