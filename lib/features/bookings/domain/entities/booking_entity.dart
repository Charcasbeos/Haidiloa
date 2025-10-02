class BookingEntity {
  final int id;
  final String phone;
  final String userId;
  final String name;
  final DateTime time;
  final DateTime createdAt;
  final int persons;
  final int? tableId;
  final String? note;
  final String? rejectReason;
  final String status;
  BookingEntity({
    required this.id,
    required this.phone,
    required this.userId,
    required this.name,
    required this.time,
    required this.createdAt,
    required this.persons,
    required this.tableId,
    required this.note,
    required this.rejectReason,
    required this.status,
  });
}
