import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';

abstract class BillState {}

class BillInitial extends BillState {}

class BillLoading extends BillState {}

class BillLoaded extends BillState {
  final BillEntity bill;
  final List<OrderEntity> orders;
  BillLoaded(this.bill, this.orders);
}

/// Danh sách tất cả bills
class BillsLoaded extends BillState {
  final List<BillEntity> bills;
  BillsLoaded(this.bills);
}

class BillEmpty extends BillState {}

class BillFailure extends BillState {
  final String message;
  BillFailure(this.message);
}

class BillRequestPayment extends BillState {
  final BillEntity bill;
  final List<OrderEntity> orders;
  BillRequestPayment(this.bill, this.orders);
}
