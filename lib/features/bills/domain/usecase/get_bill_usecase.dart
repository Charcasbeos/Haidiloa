// domain/usecase/request_payment_usecase.dart
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';
import 'package:haidiloa/features/bills/domain/repositories/bill_repository.dart';

class GetBillUsecase {
  final BillRepository repository; // repo của bill

  GetBillUsecase(this.repository);

  Future<DataState<BillEntity>> call(int billId) async {
    return await repository.getBill(billId: billId);
  }
}
