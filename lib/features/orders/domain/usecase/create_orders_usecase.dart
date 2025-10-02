import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/orders/domain/usecase/create_order_params.dart';
import 'package:haidiloa/features/orders/domain/repositories/order_repository.dart';

import '../../../../app/core/usecases/base_usecase.dart';

class CreateOrdersUsecase
    implements Usecase<DataState<void>, CreateOrdersParams> {
  final OrderRepository _orderRepository;
  CreateOrdersUsecase(this._orderRepository);

  @override
  Future<DataState<void>> call({required CreateOrdersParams params}) {
    return _orderRepository.createOrders(
      billId: params.billId,
      orders: params.orders,
    );
  }
}
