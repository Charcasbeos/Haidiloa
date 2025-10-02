import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/data/datasources/bill_remote_datasource.dart';
import 'package:haidiloa/features/bills/data/mapper/bill_mapper.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';
import 'package:haidiloa/features/bills/domain/usecase/params/create_bill_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BillRepositoryImpl extends BillRepository {
  BillRemoteDataSource billRemoteDataSource;
  BillRepositoryImpl(this.billRemoteDataSource);
  @override
  Future<DataState<int>> createBill({
    required CreateBillParams createBillParams,
  }) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        return DataError(UnknownException('Chưa đăng nhập'));
      }

      final billId = await billRemoteDataSource.insertBill(
        user.id,
        createBillParams.total,
        createBillParams.tableId,
      );

      return DataSuccess(billId);
    } on AuthException catch (e) {
      return DataError(RequestCancelledException(e.message));
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> deleteBill({required int billId}) {
    // TODO: implement deleteBill
    throw UnimplementedError();
  }

  @override
  Future<DataState<BillEntity>> getBill({required int billId}) async {
    try {
      final result = await billRemoteDataSource.getBillById(
        billId,
      ); // API thực tế
      if (result == null) {
        return DataError(UnknownException('Không tìm thấy hóa đơn'));
      }
      final bill = BillMapper.toBillEntity(BillMapper.fromJson(result));

      return DataSuccess(bill);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<List<BillEntity>>> getBills() async {
    try {
      // gọi supabase để lấy danh sách bills
      final response = await billRemoteDataSource.getBills();

      // parse sang BillEntity
      final bills = (response as List<dynamic>)
          .map((json) => BillMapper.toBillEntity(BillMapper.fromJson(json)))
          .toList();
      return DataSuccess(bills);
    } catch (e) {
      return DataError(UnknownException('Không thể tải danh sách hóa đơn: $e'));
    }
  }

  @override
  Future<DataState<void>> updateBill({required BillEntity billEntity}) {
    // TODO: implement updateBill
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> requestPayment({
    required int billId,
    required double total,
  }) async {
    try {
      await billRemoteDataSource.requestPayment(billId, total); // API thực tế
      return DataSuccess(null);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Future<DataState<List<BillEntity>>> getBillsByUserId({
    required String userId,
  }) async {
    try {
      final data = await billRemoteDataSource.getBillsByUserId(userId: userId);
      final result = data
          .map((json) => BillMapper.toBillEntity(BillMapper.fromJson(json)))
          .toList();
      return DataSuccess(result);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }

  @override
  Stream<List<BillEntity>> streamBillsByUserId(String userId) {
    return billRemoteDataSource.streamBillsByUserId(userId).asyncMap((_) async {
      final data = await billRemoteDataSource.getBillsByUserId(userId: userId);
      final result = data
          .map((json) => BillMapper.toBillEntity(BillMapper.fromJson(json)))
          .toList();
      return (result);
    });
  }

  @override
  Future<void> updateBillTotal(int billId, double total) {
    return billRemoteDataSource.updateBillTotal(billId, total);
  }

  @override
  Future<DataState<void>> updateBillPaymented(
    int billId,
    bool paymented,
  ) async {
    try {
      final res = billRemoteDataSource.updateBillPaymented(billId, paymented);
      return DataSuccess(res);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }
}
