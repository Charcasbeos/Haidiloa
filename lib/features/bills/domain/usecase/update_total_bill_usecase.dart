// update_bill_usecase.dart
import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';
import 'package:haidiloa/features/bills/domain/usecase/params/update_bill_params.dart';

class UpdateTotalBillUsecase {
  final BillRepository repository;

  UpdateTotalBillUsecase(this.repository);

  Future<DataState<void>> call(UpdateBillParams params) async {
    try {
      await repository.updateBillTotal(params.billId, params.total);
      return const DataSuccess(null);
    } catch (e) {
      return DataError(UnknownException(e.toString()));
    }
  }
}
