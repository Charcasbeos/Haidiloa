class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int point;
  final DateTime birthday;
  final String role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.point,
    required this.role,
  });
  @override
  String toString() {
    return 'UserEntity('
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
