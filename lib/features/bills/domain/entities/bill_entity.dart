class BillEntity {
  final int? id;
  final String userId;
  final DateTime createdAt;
  final int tableId;
  final bool paymented;
  final bool requestPayment;
  final double total;
  BillEntity({
    required this.id,
    required this.userId,
    required this.paymented,
    required this.tableId,
    required this.createdAt,
    required this.requestPayment,
    required this.total,
  });
  @override
  String toString() {
    return 'BillEntity('
        'id: $id, '
        'userId: $userId, '
        'createdAt: $createdAt, '
        'tableId: $tableId, '
        'paymented: $paymented, '
        'requestPayment: $requestPayment, '
        'total: $total, '
        ')';
  }

  // thêm copyWith ở đây
  BillEntity copyWith({
    int? id,
    String? userId,
    double? total,
    bool? paymented,
    bool? requestPayment,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? tableId,
  }) {
    return BillEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      total: total ?? this.total,
      paymented: paymented ?? this.paymented,
      requestPayment: requestPayment ?? this.requestPayment,
      createdAt: createdAt ?? this.createdAt,
      tableId: tableId ?? this.tableId,
    );
  }
}
