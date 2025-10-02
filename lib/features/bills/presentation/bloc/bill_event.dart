abstract class BillEvent {}

class LoadBillOrdersEvent extends BillEvent {
  final int billId;
  LoadBillOrdersEvent(this.billId);
}

class RequestPaymentEvent extends BillEvent {
  final int billId;
  final double total;
  RequestPaymentEvent(this.billId, this.total);
}

class ConfirmPaymentEvent extends BillEvent {
  final int billId;
  ConfirmPaymentEvent(this.billId);
}

/// Lấy danh sách tất cả bills (cho admin)
class GetBillsEvent extends BillEvent {
  // Nếu cần lọc theo userId thì thêm ở đây:
  final int? userId;
  GetBillsEvent({this.userId});
}
