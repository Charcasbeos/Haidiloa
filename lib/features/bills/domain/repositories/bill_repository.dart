import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bills/domain/usecase/params/create_bill_params.dart';

abstract class BillRepository {
  Future<DataState<BillEntity>> getBill({required int billId});
  Future<DataState<void>> updateBill({required BillEntity billEntity});
  Future<DataState<int>> createBill({
    required CreateBillParams createBillParams,
  });
  Future<DataState<void>> deleteBill({required int billId});
  Future<DataState<List<BillEntity>>> getBills();
  Future<DataState<List<BillEntity>>> getBillsByUserId({
    required String userId,
  });
  Future<void> updateBillTotal(int billId, double total);
  Future<DataState<void>> updateBillPaymented(int billId, bool paymented);

  /// Lấy danh sách booking theo userId REALTIME
  Stream<List<BillEntity>> streamBillsByUserId(String userId);

  Future<DataState<void>> requestPayment({
    required int billId,
    required double total,
  });
}
