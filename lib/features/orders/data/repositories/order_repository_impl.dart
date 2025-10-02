import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/data/datasources/bill_remote_datasource.dart';
import 'package:haidiloa/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:haidiloa/features/orders/data/mapper/order_mapper.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';
import 'package:haidiloa/features/orders/domain/repositories/order_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final BillRemoteDataSource billRemoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource, this.billRemoteDataSource);
  @override
  Future<DataState<void>> createOrder({
    required OrderEntity orderEntity,
  }) async {
    // TODO: implement createOrder
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> deleteOrder({required int orderId}) {
    // TODO: implement deleteOrder
    throw UnimplementedError();
  }

  @override
  Future<DataState<OrderEntity>> getOrder({required int orderId}) {
    // TODO: implement getOrder
    throw UnimplementedError();
  }

  @override
  Future<DataState<List<OrderEntity>>> getOrders() {
    // TODO: implement getOrders
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> updateOrder({required OrderEntity orderEntity}) {
    // TODO: implement updateOrder
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> createOrders({
    required int billId,
    required List<OrderEntity> orders,
  }) async {
    try {
      // 3. Lặp list và insert từng order
      for (final orderEntity in orders) {
        final orderModel = OrderMapper.toOrderModel(orderEntity);
        // print(orderModel);
        await remoteDataSource.createOrder({
          'bill_id': billId,
          'dish_id': orderModel.dishId,
          'name': orderModel.name,
          'price': orderModel.price,
          'quantity': orderModel.quantity,
          'image_url': orderModel.imageURL,
        });
      }

      return const DataSuccess(null);
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<List<OrderEntity>>> getOrdersByBillId({
    required int billId,
  }) async {
    try {
      // gọi remote datasource trả về List<Map<String,dynamic>>
      final result = await remoteDataSource.getOrdersByBillId(billId);
      // json -> OrderModel -> OrderEntity
      final orders = result
          .map((json) => OrderMapper.toOrderEntity(OrderMapper.fromJson(json)))
          .toList();
      return DataSuccess(orders);
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }
}
