// order_event.dart
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';

abstract class OrderEvent {}

class AddItemEvent extends OrderEvent {
  final DishEntity dish;
  AddItemEvent(this.dish);
}

class RemoveItemEvent extends OrderEvent {
  final DishEntity dish;
  RemoveItemEvent(this.dish);
}

class ClearOrderEvent extends OrderEvent {}

class SubmitOrdersEvent extends OrderEvent {
  final List<OrderEntity> orders;
  int tableId;
  SubmitOrdersEvent(this.orders, this.tableId);
}

// đã yêu cầu thanh toán
class BillRequestedPaymentEvent extends OrderEvent {
  final bool requestPayment;
  BillRequestedPaymentEvent(this.requestPayment);
}

class GetBillEvent extends OrderEvent {
  final int billId;
  GetBillEvent(this.billId);
}

// thanh toán thành công
class BillPaymentedEvent extends OrderEvent {}
