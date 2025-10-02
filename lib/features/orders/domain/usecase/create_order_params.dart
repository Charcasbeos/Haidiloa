import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';

class CreateOrdersParams {
  final int billId;
  final List<OrderEntity> orders;

  CreateOrdersParams({required this.billId, required this.orders});
}
