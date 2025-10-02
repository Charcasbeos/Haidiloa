import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<DataState<OrderEntity>> getOrder({required int orderId});
  Future<DataState<List<OrderEntity>>> getOrdersByBillId({required int billId});
  Future<DataState<void>> updateOrder({required OrderEntity orderEntity});
  Future<DataState<void>> createOrder({required OrderEntity orderEntity});
  Future<DataState<void>> createOrders({
    required int billId,
    required List<OrderEntity> orders,
  });
  Future<DataState<void>> deleteOrder({required int orderId});
  Future<DataState<List<OrderEntity>>> getOrders();
}
