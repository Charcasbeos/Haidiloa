import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';
import 'package:haidiloa/features/orders/domain/repositories/order_repository.dart';

class GetOrdersByBillIdUsecase {
  final OrderRepository _orderRepository;
  GetOrdersByBillIdUsecase(this._orderRepository);

  Future<DataState<List<OrderEntity>>> call(int billId) {
    return _orderRepository.getOrdersByBillId(billId: billId);
  }
}
