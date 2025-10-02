class BillModel {
  final int? id;
  final String userId;
  final DateTime createdAt;
  final int tableId;
  final bool paymented;
  final bool requestPayment;
  final double total;
  BillModel({
    required this.id,
    required this.userId,
    required this.paymented,
    required this.createdAt,
    required this.tableId,
    required this.requestPayment,
    required this.total,
  });
  @override
  String toString() {
    return 'BillModel('
        'id: $id, '
        'userId: $userId, '
        'createdAt: $createdAt, '
        'tableId: $tableId, '
        'paymented: $paymented, '
        'requestPayment: $requestPayment, '
        'total: $total, '
        ')';
  }
}
