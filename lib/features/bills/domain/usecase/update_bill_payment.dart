import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';

class UpdateBillPaymentedUsecase {
  final BillRepository repo;
  UpdateBillPaymentedUsecase(this.repo);

  Future<DataState<void>> call(int billId, bool paymented) {
    return repo.updateBillPaymented(billId, paymented);
  }
}
