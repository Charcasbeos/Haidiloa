import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/orders/domain/repositories/order_repository.dart';

import '../../../../app/core/usecases/base_usecase.dart';

class GetOrderUsecase implements Usecase<DataState<void>, int> {
  final OrderRepository _orderRepository;
  GetOrderUsecase(this._orderRepository);

  @override
  Future<DataState<void>> call({required int params}) {
    return _orderRepository.getOrder(orderId: params);
  }
}
