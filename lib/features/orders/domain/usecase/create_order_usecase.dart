import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';
import 'package:haidiloa/features/orders/domain/repositories/order_repository.dart';

import '../../../../app/core/usecases/base_usecase.dart';

class CreateOrderUsecase implements Usecase<DataState<void>, OrderEntity> {
  final OrderRepository _orderRepository;
  CreateOrderUsecase(this._orderRepository);

  @override
  Future<DataState<void>> call({required OrderEntity params}) {
    return _orderRepository.createOrder(orderEntity: params);
  }
}
